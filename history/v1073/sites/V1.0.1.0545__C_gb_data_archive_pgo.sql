-- auto gen by george 2017-10-07 10:36:58
DROP FUNCTION IF EXISTS gb_data_archive_pgo(TEXT, TIMESTAMP, TIMESTAMP);
CREATE OR REPLACE FUNCTION gb_data_archive_pgo(
  p_archive_month  TEXT,
  p_start_time   TIMESTAMP,
  p_end_time   TIMESTAMP
) returns INT as $$
/*版本更新说明
  版本   时间        作者    内容
--v1.00  2017/02/20  Laser   创建此函数:数据归档-pgo
--v2.00  2017/10/05  Laser   新增pgo未稽核表，允许归档所有已结算数据

*/
DECLARE

  d_archive_month DATE;
  v_rel_name    VARCHAR;
  arr_rel_name  VARCHAR[];
  v_source_name VARCHAR;
  n_rel_count   INT;
  n_count  INT;

BEGIN

  d_archive_month := to_date(p_archive_month, 'YYYY-MM');

  IF now() - p_end_time < '40 day' THEN
    RAISE INFO '距离当前日期小于40天，不能进行归档！';
    RETURN 1;
  END IF;

  IF d_archive_month < '2016-10-01' THEN
    v_rel_name = 'player_game_order_bak_20161001';
  ELSE
    v_rel_name = 'player_game_order_bak_' || to_char(d_archive_month, 'YYYYMM');
  END IF;

  arr_rel_name = array_append( arr_rel_name, v_rel_name);

  IF d_archive_month >= '2017-08-01' THEN --8月新增detail表
     v_rel_name = 'player_game_order_detail_bak_' || to_char(d_archive_month, 'YYYYMM');
     arr_rel_name = array_append( arr_rel_name, v_rel_name);
  END IF;

  v_rel_name = '';
  FOR v_rel_name IN SELECT unnest(arr_rel_name)
  LOOP

    IF position('detail' in v_rel_name) > 0 THEN
      v_source_name = 'player_game_order_detail';
    ELSE
      v_source_name = 'player_game_order';
    END IF;
    SELECT COUNT(*)
      INTO n_rel_count
      FROM pg_catalog.pg_class c
           LEFT JOIN pg_catalog.pg_namespace n ON n.oid = c.relnamespace
     WHERE c.relname = v_rel_name
       AND pg_catalog.pg_table_is_visible(c.oid);

    IF n_rel_count = 0 THEN
      EXECUTE 'CREATE TABLE ' || v_rel_name || ' ( LIKE '|| v_source_name || ' INCLUDING COMMENTS )';
    END IF;

    EXECUTE 'WITH t AS ' ||
            '( DELETE FROM ' || v_source_name || ' pgo '||
            '   WHERE order_state IN (''settle'', ''cancel'')' ||
            '     AND payout_time >= ''' || p_start_time::TEXT || '''' ||
            '     AND payout_time < ''' || p_end_time::TEXT || '''
               RETURNING * ) ' ||
            'INSERT INTO ' || v_rel_name || ' SELECT * FROM t';

    GET DIAGNOSTICS n_count = ROW_COUNT;
    raise notice '% 本次归档记录数 %', v_rel_name, n_count;

  END LOOP;

  RETURN 0;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_data_archive_pgo(d_archive_month TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP)
IS 'Laser-数据归档pgo';


DROP FUNCTION IF EXISTS gb_rakeback_task(TEXT, TEXT, TEXT, TEXT, TEXT);
CREATE OR REPLACE FUNCTION gb_rakeback_task(
  p_comp_url  TEXT,
  p_period   TEXT,
  p_start_time   TEXT,
  p_end_time   TEXT,
  p_settle_flag   TEXT
) RETURNS INT as $$
/*版本更新说明
  版本   时间        作者    内容
--v1.00  2017/06/17  Laser   创建此函数: 返水结算账单.入口(调度)
--v1.01  2017/10/06  Laser   dblink_connect_u

  返回值说明：0成功，1警告，2错误
*/
DECLARE

  t_start_time   TIMESTAMP;
  t_end_time   TIMESTAMP;
  n_sid  INT;
  n_return_code INT := 0;

  text_var1 TEXT;
  text_var2 TEXT;
  text_var3 TEXT;
  text_var4 TEXT;

BEGIN

  t_start_time = clock_timestamp()::timestamp(0);

  perform gb_rakeback(p_period, p_start_time, p_end_time, p_settle_flag);

  t_end_time = clock_timestamp()::timestamp(0);

  IF p_settle_flag = 'Y' THEN

    SELECT gamebox_current_site() INTO n_sid;

    --v1.01  2017/10/06  Laser
    perform dblink_close_all();
    perform dblink_connect_u('mainsite',  p_comp_url);

    SELECT t.return_code
      INTO n_return_code
      FROM
      dblink ('mainsite',
              'SELECT * from gb_task_infomation_site( ''' || n_sid || ''', ''gb_rakeback'', ''返水结算账单'', ''' || p_period || ''', ''1'', ''' ||
               t_start_time || ''', ''' || t_end_time || ''', '''')'
             ) AS t(return_code INT);
    perform dblink_disconnect('mainsite');
  END IF;

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

COMMENT ON FUNCTION gb_rakeback_task( p_comp_url  TEXT, p_period TEXT, p_start_time TEXT, p_end_time TEXT, p_settle_flag TEXT)
IS 'Laser-返水结算账单.入口(调度)';


DROP FUNCTION IF EXISTS gb_rakeback_recount(TEXT, TEXT, TEXT, TEXT, TEXT);
CREATE OR REPLACE FUNCTION gb_rakeback_recount(
  p_comp_url  TEXT,
  p_period   TEXT,
  p_start_time   TEXT,
  p_end_time   TEXT,
  p_settle_flag   TEXT
) returns INT as $$
/*版本更新说明
  版本   时间        作者    内容
--v1.00  2017/06/26  Laser   创建此函数: 返水结算账单.返水补差
--v1.01  2017/07/18  Laser   增加更新API反水表，更新返水发放、拒绝人数
--v1.02  2017/07/26  Laser   更改ON CONFLICT的写法，方便理解，rakeback_total从player表统计
--v1.03  2017/07/28  Laser   更改rakeback_player、rakeback_api的更新条件，只要重结后rakeback_pending>=0的都允许重结
--v1.04  2017/09/18  Laser   修正某些情况下rakeback_bill.lssuing_state统计错误的问题
--v1.04  2017/10/05  Laser   增加对重结出现新的游戏类型的支持

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
  n_rakeback_total     FLOAT := 0;

  v_lssuing_state varchar(32);

  v_remark varchar(50) := '';
  v_sql text;

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
    --v1.03  2017/07/28  Laser
    /*
    DELETE FROM rakeback_api ra
     WHERE rakeback_bill_id = rec_rb.id
       AND EXISTS (SELECT 1
                     FROM rakeback_api_nosettled
                    WHERE rakeback_bill_nosettled_id = rec_rbn.id
                      AND player_id = ra.player_id
                      AND api_id = ra.api_id
                      AND game_type = ra.game_type
                      AND rakeback > ra.rakeback);
    */

    --rakeback_player的条件必须和下面更新Player反水表的一样
    --v1.04  2017/10/05  Laser
    /*
    DELETE FROM rakeback_api ra
     WHERE rakeback_bill_id = rec_rb.id
       AND EXISTS (SELECT 1
                     FROM rakeback_api_nosettled
                    WHERE rakeback_bill_nosettled_id = rec_rbn.id
                      AND player_id = ra.player_id
                      AND api_id = ra.api_id
                      AND game_type = ra.game_type
                      AND rakeback <> ra.rakeback)
       AND EXISTS (SELECT 1
                     FROM rakeback_player rp RIGHT JOIN rakeback_player_nosettled rpn
                       ON rp.rakeback_bill_id = rec_rb.id AND rpn.rakeback_bill_nosettled_id = rec_rbn.id AND rp.player_id=rpn.player_id
                    WHERE rpn.rakeback_total <> COALESCE(rp.rakeback_total, 0)
                      AND rpn.rakeback_total - COALESCE(rp.rakeback_total, 0) + COALESCE(rp.rakeback_pending, 0) >= 0 --最终得到的返水未结值不能小于0
                      AND rpn.player_id = ra.player_id
                  );
    */
    DELETE FROM rakeback_api ra
     WHERE rakeback_bill_id = rec_rb.id
       AND NOT EXISTS ( SELECT 1
                          FROM rakeback_api_nosettled
                         WHERE rakeback_bill_nosettled_id = rec_rbn.id
                           AND player_id = ra.player_id
                           AND api_id = ra.api_id
                           AND game_type = ra.game_type
                           AND rakeback = ra.rakeback ) --重结后没有这条记录，或者返水值不相等
       AND NOT EXISTS ( SELECT 1
                          FROM rakeback_player rp RIGHT JOIN rakeback_player_nosettled rpn
                            ON rp.rakeback_bill_id = rec_rb.id AND rpn.rakeback_bill_nosettled_id = rec_rbn.id AND rp.player_id=rpn.player_id
                         WHERE rpn.rakeback_total - COALESCE(rp.rakeback_total, 0) + COALESCE(rp.rakeback_pending, 0) < 0 --最终得到的返水未结值不能小于0
                           AND rpn.player_id = ra.player_id
                      ); --重结后没有这个玩家、或者重结后的返水未结值>=0

    INSERT INTO rakeback_api (
        rakeback_bill_id, player_id, api_id, game_type, effective_transaction, profit_loss, rakeback, api_type_id, audit_num, rakeback_limit)
    SELECT rec_rb.id, player_id, api_id, game_type, effective_transaction, profit_loss, rakeback, api_type_id, audit_num, rakeback_limit
      FROM rakeback_api_nosettled
     WHERE rakeback_bill_nosettled_id = rec_rbn.id
    --v1.02  2017/07/26  Laser
    --ON CONFLICT ON CONSTRAINT rakeback_api_rpag_uc
    ON CONFLICT (rakeback_bill_id, player_id, api_id, game_type)
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
          COALESCE(rp.rakeback_paid, 0) rakeback_paid, --已付返水
          rpn.rakeback_total - COALESCE(rp.rakeback_total, 0) + COALESCE(rp.rakeback_pending, 0) rakeback_pending --返水差额 +此前未结
        FROM rpn
        LEFT JOIN rp ON rpn.player_id = rp.player_id
       --v1.03  2017/07/28  Laser
       --WHERE rpn.rakeback_total > COALESCE(rp.rakeback_total, 0)
       WHERE rpn.rakeback_total <> COALESCE(rp.rakeback_total, 0)
         AND rpn.rakeback_total - COALESCE(rp.rakeback_total, 0) + COALESCE(rp.rakeback_pending, 0) >= 0 --最终得到的返水未结值不能小于0
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
    --v1.02  2017/07/26  Laser
    --ON CONFLICT ON CONSTRAINT rakeback_player_rp_uc
    ON CONFLICT (rakeback_bill_id, player_id)
    DO UPDATE SET rakeback_total   = excluded.rakeback_total,
                  rakeback_actual  = excluded.rakeback_pending,
                  rakeback_pending = excluded.rakeback_pending,
                  settlement_state = 'pending_lssuing',
                  remark = COALESCE(rakeback_player.remark, '返水补差');

    --v1.01  2017/07/18  Laser
    --返水发放、拒绝人数
    SELECT COUNT(player_id),
           SUM( CASE settlement_state WHEN 'lssuing' THEN 1 ELSE 0 END),
           SUM( CASE settlement_state WHEN 'reject_lssuing' THEN 1 ELSE 0 END),
           SUM( rakeback_total) --v1.02  2017/07/26
      INTO n_player_count,
           n_player_lssuing_count,
           n_player_reject_count,
           n_rakeback_total
      FROM rakeback_player
     WHERE rakeback_bill_id = rec_rb.id;

    --v1.04  2017/09/18  Laser
    v_lssuing_state := 'part_pay';
    IF n_player_lssuing_count + n_player_reject_count = 0 THEN
      v_lssuing_state := 'pending_pay';
    ELSEIF n_player_count = n_player_lssuing_count + n_player_reject_count THEN
      v_lssuing_state := 'all_pay';
    END IF;

    --更新返水总表
    UPDATE rakeback_bill rb
       SET player_count = n_player_count,
           player_lssuing_count = n_player_lssuing_count,
           player_reject_count = n_player_reject_count,
           rakeback_total = n_rakeback_total, --v1.02  2017/07/26
           rakeback_pending = n_rakeback_total - rb.rakeback_total + rb.rakeback_pending,
           --v1.04  2017/09/18  Laser
           --lssuing_state = CASE rb.lssuing_state WHEN 'pending_pay' THEN 'pending_pay' ELSE 'part_pay' END
           lssuing_state = v_lssuing_state
      FROM ( SELECT * FROM rakeback_bill_nosettled rbni WHERE rbni.id = rec_rbn.id ) rbn
     WHERE rb.id = rec_rb.id
       AND rb.rakeback_total <> rbn.rakeback_total;
  END IF;

  t_end_time = clock_timestamp()::timestamp(0);

  SELECT gamebox_current_site() INTO n_sid;

  --perform dblink_close_all();
  --perform dblink_connect('master',  p_comp_url);
  v_sql = 'SELECT * from gb_task_infomation_site( ''' || n_sid || ''', ''gb_rakeback_recount'', ''返水补差'', ''' || p_period || ''', ''1'', ''' ||
           t_start_time || ''', ''' || t_end_time || ''', ''' || v_remark || ''')';
  RAISE INFO '%', v_sql;

  IF 'mainsite' IN ( SELECT unnest(dblink_get_connections()) ) THEN
    PERFORM dblink_disconnect('mainsite');
  END IF;

  PERFORM dblink_connect_u('mainsite', p_comp_url);

  SELECT t.return_code
    INTO n_return_code
    FROM
    dblink ('mainsite',
            v_sql
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
IS 'Laser-返水结算账单.返水补差';