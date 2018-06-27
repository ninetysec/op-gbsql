DROP FUNCTION IF EXISTS gb_rakeback_api(INT, TEXT, TIMESTAMP, TIMESTAMP);
CREATE OR REPLACE FUNCTION gb_rakeback_api(
  p_bill_id   INT,
  p_settle_flag   TEXT,
  p_start_time   TIMESTAMP,
  p_end_time   TIMESTAMP
) returns void as $$
/*版本更新说明
  版本   时间        作者   内容
--v1.00  2017/01/15  Laser  创建此函数: 返水结算账单.玩家API返水.NEW
--v1.01  2017/01/22  Laser  针对1万个玩家以上返水较慢问题，重写此过程以优化性能。
                              变化和影响: 新版要求每个玩家必须设置返水方案
--v1.02  2018/01/08  Laser  记录投注大于0，但是没有产生返水的记录，便于排查
*/
DECLARE

BEGIN

  RAISE INFO 'gb_rakeback_api.BEGIN: %', clock_timestamp();

  IF p_settle_flag = 'Y' THEN

    WITH
    p_grad AS --返水梯度
    (
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
    pag AS --注单信息
    (
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
    ra AS --玩家返水
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
       --WHERE ratio > 0 --v1.01  2018/01/08  Laser
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
       --WHERE ratio > 0 --v1.01  2018/01/08  Laser
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
IS 'Laser-返水结算账单.玩家API返水.NEW';
