-- auto gen by cherry 2017-07-24 14:34:27
DROP FUNCTION IF EXISTS gb_rakeback_recount(TEXT, TEXT, TEXT, TEXT, TEXT);
CREATE OR REPLACE FUNCTION gb_rakeback_recount(
  p_comp_url  TEXT,
  p_period   TEXT,
  p_start_time   TEXT,
  p_end_time   TEXT,
  p_settle_flag   TEXT
) returns INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/06/26  Leisure  创建此函数: 返水结算账单.返水补差
--v1.01  2017/07/18  Leisure  增加更新API反水表，更新返水、发放、拒绝人数

  返回值说明：0成功，1警告，2错误
*/
DECLARE

  t_start_time   TIMESTAMP;
  t_end_time   TIMESTAMP;
  n_sid  INT;
  n_return_code INT := 0;

  --rec_rb.id INT;
  --rec_rbn.id INT;

  rec_rb  RECORD;
  rec_rbn RECORD;

  n_player_count         INT := 0;
  n_player_lssuing_count INT := 0;
  n_player_reject_count  INT := 0;

  v_remark varchar(50) := '';
  t_sql text;

  text_var1 TEXT;
  text_var2 TEXT;
  text_var3 TEXT;
  text_var4 TEXT;

BEGIN

  t_start_time = clock_timestamp()::timestamp(0);

  perform gb_rakeback(p_period, p_start_time, p_end_time, 'N');

  BEGIN

    SELECT *
      INTO rec_rb
      FROM rakeback_bill WHERE start_time = p_start_time::TIMESTAMP;

    IF NOT FOUND THEN
      RAISE NOTICE '本期返水未结算，不能执行返水补差操作！';
      RETURN 2;
    END IF;

    SELECT *
      INTO rec_rbn
      FROM rakeback_bill_nosettled WHERE start_time = p_start_time::TIMESTAMP;

    IF NOT FOUND THEN
      RAISE NOTICE '本期返水补差账单未生成，不能执行返水补差操作！';
      RETURN 2;
    END IF;

  EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE '本期返水账单异常，任务失败！';
    RETURN 2;
  END;

  IF rec_rb.player_count = rec_rbn.player_count AND rec_rb.rakeback_total = rec_rbn.rakeback_total THEN
    RAISE NOTICE '返水人数、总额无变化，不需要返水补差！';
    v_remark = '返水人数、总额无变化，不需要返水补差！';
  ELSE

    --更新返水结算账单
    --更新API反水表
    DELETE FROM rakeback_api ra
     WHERE rakeback_bill_id = rec_rb.id
       AND EXISTS (SELECT 1
                     FROM rakeback_api_nosettled
                    WHERE player_id = ra.player_id AND api_id = ra.api_id AND game_type = ra.game_type AND rakeback > ra.rakeback);

    INSERT INTO rakeback_api (
        rakeback_bill_id, player_id, api_id, game_type, effective_transaction, profit_loss, rakeback, api_type_id, audit_num, rakeback_limit)
    SELECT rec_rb.id, player_id, api_id, game_type, effective_transaction, profit_loss, rakeback, api_type_id, audit_num, rakeback_limit
      FROM rakeback_api_nosettled
     WHERE rakeback_bill_nosettled_id = rec_rbn.id
    ON CONFLICT ON CONSTRAINT rakeback_player_rpag_uc
    DO NOTHING;

    --更新Player反水表
    WITH rpn AS (
      SELECT * FROM rakeback_player_nosettled WHERE rakeback_bill_nosettled_id = rec_rbn.id
    ),
    rp AS (
      SELECT * FROM rakeback_player WHERE rakeback_bill_id = rec_rb.id
    ),
    rpj AS (
      SELECT
          rpn.*,
          COALESCE(rp.rakeback_paid, 0.00) rakeback_paid, --已付返水
          rpn.rakeback_total - COALESCE(rp.rakeback_total, 0.00) + COALESCE(rp.rakeback_pending, 0.00) rakeback_pending --返水差额 +此前未结
        FROM rpn
        LEFT JOIN rp ON rpn.player_id = rp.player_id
       WHERE rpn.rakeback_total > COALESCE(rp.rakeback_total, -1)
    )
    --SELECT * FROM rpj
    INSERT INTO rakeback_player (
        rakeback_bill_id, player_id, username, rank_id, rank_name, risk_marker, settlement_state, remark,
        agent_id, top_agent_id, audit_num, rakeback_total, rakeback_actual, rakeback_paid, rakeback_pending
    )
    SELECT rec_rb.id, player_id, username, rank_id, rank_name, risk_marker, 'pending_lssuing', '返水补差',
           agent_id, top_agent_id, audit_num, rakeback_total, rakeback_pending, rakeback_paid, rakeback_pending
      FROM rpj
     --WHERE rakeback_total <> 0
    ON CONFLICT ON CONSTRAINT rakeback_player_rp_uc
    DO UPDATE SET rakeback_total   = excluded.rakeback_total,
                  rakeback_actual  = excluded.rakeback_pending,
                  rakeback_pending = excluded.rakeback_pending,
                  settlement_state = 'pending_lssuing',
                  remark = COALESCE(rakeback_player.remark, '返水补差');

    SELECT COUNT(player_id),
           SUM( CASE settlement_state WHEN 'lssuing' THEN 1 ELSE 0 END),
           SUM( CASE settlement_state WHEN 'reject_lssuing' THEN 1 ELSE 0 END)
      INTO n_player_count,
           n_player_lssuing_count,
           n_player_reject_count
      FROM rakeback_player
     WHERE rakeback_bill_id = rec_rb.id;

    --更新返水总表
    UPDATE rakeback_bill rb
       SET player_count = n_player_count,
           player_lssuing_count = n_player_lssuing_count,
           player_reject_count = n_player_reject_count,
           rakeback_total = rbn.rakeback_total,
           rakeback_pending = rbn.rakeback_total - rb.rakeback_total + rb.rakeback_pending,
           lssuing_state = CASE rb.lssuing_state WHEN 'pending_pay' THEN 'pending_pay' ELSE 'part_pay' END
      FROM ( SELECT * FROM rakeback_bill_nosettled rbni WHERE rbni.id = rec_rbn.id ) rbn
     WHERE rb.id = rec_rb.id
       AND rb.rakeback_total <> rbn.rakeback_total;
  END IF;

  t_end_time = clock_timestamp()::timestamp(0);

  SELECT gamebox_current_site() INTO n_sid;

  --perform dblink_close_all();
  --perform dblink_connect('master',  p_comp_url);
  t_sql = 'SELECT * from gb_task_infomation_site( ''' || n_sid || ''', ''gb_rakeback_recount'', ''返水补差'', ''' || p_period || ''', ''1'', ''' ||
           t_start_time || ''', ''' || t_end_time || ''', ''' || v_remark || ''')';
  RAISE INFO '%', t_sql;

  IF 'mainsite' IN ( SELECT unnest(dblink_get_connections()) ) THEN
    PERFORM dblink_disconnect('mainsite');
  END IF;

  PERFORM dblink_connect_u('mainsite', p_comp_url);

  SELECT t.return_code
    INTO n_return_code
    FROM
    dblink ('mainsite',
            t_sql
           ) AS t(return_code INT);
  --perform dblink_disconnect('master');

  PERFORM dblink_disconnect('mainsite');
  --PERFORM dblink_close('mainsite');

  IF n_return_code <> 0 THEN
    RAISE INFO '任务记录未成功写入远端表';
  END IF;

RETURN 0;

EXCEPTION
  WHEN QUERY_CANCELED THEN
    RETURN 2;
  WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT,
                            text_var2 = PG_EXCEPTION_DETAIL,
                            text_var3 = PG_EXCEPTION_HINT,
                            text_var4 = PG_EXCEPTION_CONTEXT;
    RAISE NOTICE  E'--- EXCEPTION ---\n%\n%\n%', text_var1, text_var2, text_var3;

    --GET DIAGNOSTICS text_var4 = PG_CONTEXT;
    RAISE NOTICE E'--- Call Stack ---\n%', text_var4;

    RETURN 2;
END;

$$ language plpgsql;

COMMENT ON FUNCTION gb_rakeback_recount( p_comp_url  TEXT, p_period TEXT, p_start_time TEXT, p_end_time TEXT, p_settle_flag TEXT)
IS 'Leisure-返水结算账单.返水补差';


DROP FUNCTION IF EXISTS gb_rakeback_api(INT, TEXT, TIMESTAMP, TIMESTAMP);
CREATE OR REPLACE FUNCTION gb_rakeback_api(
  p_bill_id   INT,
  p_settle_flag   TEXT,
  p_start_time   TIMESTAMP,
  p_end_time   TIMESTAMP
) returns void as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/01/15  Leisure  创建此函数: 返水结算账单.玩家API返水.NEW
--v1.01  2017/01/22  Leisure  针对1万个玩家以上返水较慢问题，重写此过程以优化性能。
                              变化和影响: 新版要求每个玩家必须设置返水方案
*/
DECLARE

BEGIN

  RAISE INFO 'gb_rakeback_api.BEGIN: %', clock_timestamp();

  IF p_settle_flag = 'Y' THEN

    WITH
    p_grad AS (
      SELECT su."id"                   as player_id,
             su.username               as player_name,
             up.rakeback_id            as rakeback_id,
             --ua."id"                   as agent_id,
             --ua.username               as agent_name,
             --ut."id"                   as topagent_id,
             --ut.username               as topagent_name,
             pgo.effective_transaction,
             pgo.profit_amount,
             rs.audit_num,
             rs.id rakeback_set_id,
             rg.id rakeback_grads_id,
             rg.max_rakeback
        FROM
      (
        SELECT player_id,
               COALESCE( SUM(pg.effective_trade_amount), 0.00) as effective_transaction,
               COALESCE( SUM(pg.profit_amount), 0.00) as profit_amount
            FROM player_game_order pg
         WHERE pg.order_state = 'settle'
           --AND pgo.is_profit_loss = TRUE
           AND pg.payout_time >= p_start_time
           AND pg.payout_time < p_end_time
         GROUP BY player_id
        --HAVING SUM(pg.effective_trade_amount) > 100
      ) pgo
          LEFT JOIN user_player up ON pgo.player_id = up."id"
          LEFT JOIN sys_user su ON up.id = su."id"  AND su.user_type = '24'
          --LEFT JOIN sys_user ua ON su.owner_id = ua.id AND ua.user_type = '23'
          --LEFT JOIN sys_user ut ON ua.owner_id = ut.id AND ut.user_type = '22'

          LEFT JOIN rakeback_set rs ON up.rakeback_id = rs.id

          LEFT JOIN rakeback_grads rg ON rg.id = ( SELECT rg.id AS rakeback_grads_id
                                                     FROM rakeback_grads rg
                                                    WHERE rg.rakeback_id = rs.id
                                                      AND pgo.effective_transaction >= rg.valid_value
                                                    ORDER BY rg.valid_value DESC LIMIT 1)
       WHERE rg.id IS NOT NULL
       ORDER BY effective_transaction DESC, su."id"
    ),
    pag AS (
      SELECT pgo.player_id,
             pgo.api_id,
             pgo.game_type,
             COALESCE(SUM(effective_trade_amount), 0.00) as effective_transaction,
             COALESCE(SUM(-pgo.profit_amount), 0.00)  as profit_amount
        FROM player_game_order pgo
        LEFT JOIN sys_user su ON pgo.player_id = su."id"
          --LEFT JOIN sys_user ua ON su.owner_id = ua.id
       WHERE pgo.order_state = 'settle'
         --AND pgo.is_profit_loss = TRUE
         AND pgo.payout_time >= p_start_time
         AND pgo.payout_time < p_end_time
         AND su.user_type = '24'
         --AND ua.user_type = '23'
         --AND su."id" = n_player_id
       GROUP BY pgo.player_id, pgo.api_id, pgo.game_type
    ),
    ra AS
    (
      SELECT
          pag.player_id,
          pag.api_id,
          pag.game_type,
          pag.effective_transaction,
          pag.profit_amount profit_loss,
          --rga.ratio,
          (pag.effective_transaction * rga.ratio/100)::NUMERIC(20, 2) rakeback,
          p_grad.audit_num,
          p_grad.max_rakeback rakeback_limit
        FROM
          pag INNER JOIN
          p_grad ON pag.player_id = p_grad.player_id
           LEFT JOIN
          rakeback_grads_api rga ON rga.id = ( SELECT id
                                                 FROM rakeback_grads_api
                                                WHERE rakeback_grads_id = p_grad.rakeback_grads_id
                                                  AND api_id = pag.api_id
                                                  AND game_type = pag.game_type
                                                LIMIT 1)
       WHERE ratio > 0
       ORDER BY pag.effective_transaction DESC
     )
     INSERT INTO rakeback_api ( rakeback_bill_id, player_id, api_id, game_type, rakeback, effective_transaction,
         profit_loss, audit_num, rakeback_limit )
     SELECT p_bill_id, player_id, api_id, game_type, rakeback, effective_transaction,
         profit_loss, audit_num, rakeback_limit
       FROM ra;

  ELSEIF p_settle_flag = 'N' THEN

    WITH
    p_grad AS (
      SELECT su."id"                   as player_id,
             su.username               as player_name,
             up.rakeback_id            as rakeback_id,
             --ua."id"                   as agent_id,
             --ua.username               as agent_name,
             --ut."id"                   as topagent_id,
             --ut.username               as topagent_name,
             pgo.effective_transaction,
             pgo.profit_amount,
             rs.audit_num,
             rs.id rakeback_set_id,
             rg.id rakeback_grads_id,
             rg.max_rakeback
        FROM
      (
        SELECT player_id,
               COALESCE( SUM(pg.effective_trade_amount), 0.00) as effective_transaction,
               COALESCE( SUM(pg.profit_amount), 0.00) as profit_amount
            FROM player_game_order pg
         WHERE pg.order_state = 'settle'
           --AND pgo.is_profit_loss = TRUE
           AND pg.payout_time >= p_start_time
           AND pg.payout_time < p_end_time
         GROUP BY player_id
        --HAVING SUM(pg.effective_trade_amount) > 100
      ) pgo
          LEFT JOIN user_player up ON pgo.player_id = up."id"
          LEFT JOIN sys_user su ON up.id = su."id"  AND su.user_type = '24'
          --LEFT JOIN sys_user ua ON su.owner_id = ua.id AND ua.user_type = '23'
          --LEFT JOIN sys_user ut ON ua.owner_id = ut.id AND ut.user_type = '22'

          LEFT JOIN rakeback_set rs ON up.rakeback_id = rs.id

          LEFT JOIN rakeback_grads rg ON rg.id = ( SELECT rg.id AS rakeback_grads_id
                                                     FROM rakeback_grads rg
                                                    WHERE rg.rakeback_id = rs.id
                                                      AND pgo.effective_transaction >= rg.valid_value
                                                    ORDER BY rg.valid_value DESC LIMIT 1)
       WHERE rg.id IS NOT NULL
       ORDER BY effective_transaction DESC, su."id"
    ),
    pag AS (
      SELECT pgo.player_id,
             pgo.api_id,
             pgo.game_type,
             COALESCE(SUM(effective_trade_amount), 0.00) as effective_transaction,
             COALESCE(SUM(-pgo.profit_amount), 0.00)  as profit_amount
        FROM player_game_order pgo
        LEFT JOIN sys_user su ON pgo.player_id = su."id"
          --LEFT JOIN sys_user ua ON su.owner_id = ua.id
       WHERE pgo.order_state = 'settle'
         --AND pgo.is_profit_loss = TRUE
         AND pgo.payout_time >= p_start_time
         AND pgo.payout_time < p_end_time
         AND su.user_type = '24'
         --AND ua.user_type = '23'
         --AND su."id" = n_player_id
       GROUP BY pgo.player_id, pgo.api_id, pgo.game_type
    ),
    ra AS
    (
      SELECT
          pag.player_id,
          pag.api_id,
          pag.game_type,
          pag.effective_transaction,
          pag.profit_amount profit_loss,
          --rga.ratio,
          (pag.effective_transaction * rga.ratio/100)::NUMERIC(20, 2) rakeback,
          p_grad.audit_num,
          p_grad.max_rakeback rakeback_limit
        FROM
          pag INNER JOIN
          p_grad ON pag.player_id = p_grad.player_id
           LEFT JOIN
          rakeback_grads_api rga ON rga.id = ( SELECT id
                                                 FROM rakeback_grads_api
                                                WHERE rakeback_grads_id = p_grad.rakeback_grads_id
                                                  AND api_id = pag.api_id
                                                  AND game_type = pag.game_type
                                                LIMIT 1)
       WHERE ratio > 0
       ORDER BY pag.effective_transaction DESC
     )
     INSERT INTO rakeback_api_nosettled ( rakeback_bill_nosettled_id, player_id, api_id, game_type, rakeback, effective_transaction,
         profit_loss, audit_num, rakeback_limit )
     SELECT p_bill_id, player_id, api_id, game_type, rakeback, effective_transaction,
         profit_loss, audit_num, rakeback_limit
       FROM ra;

  END IF;

  RAISE INFO 'gb_rakeback_api.END: %', clock_timestamp();

END;
$$ language plpgsql;

COMMENT ON FUNCTION gb_rakeback_api(p_bill_id INT, p_settle_flag TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP)
IS 'Leisure-返水结算账单.玩家API返水.NEW';