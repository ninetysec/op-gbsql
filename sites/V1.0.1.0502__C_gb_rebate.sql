-- auto gen by cherry 2017-08-16 10:07:21
DROP FUNCTION IF EXISTS gb_rebate(text, text, text, text);
CREATE OR REPLACE FUNCTION gb_rebate (
  p_period   text,
  p_start_time   text,
  p_end_time   text,
  p_settle_flag   text
) returns INT as $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/10/08  Leisure   创建此函数: 返佣结算账单-入口（新）
--v1.00  2017/07/31  Leisure   增加多级代理返佣支持

*/
DECLARE

  t_start_time   TIMESTAMP;
  t_end_time   TIMESTAMP;

  n_rebate_bill_id INT:=-1; --返佣主表键值
  n_bill_count   INT :=0;

  n_sid       INT;--站点ID

  redo_status BOOLEAN:=false; --重跑标志，默认不允许重跑

BEGIN
  t_start_time = p_start_time::TIMESTAMP;
  t_end_time = p_end_time::TIMESTAMP;

  IF p_settle_flag = 'Y' THEN
    SELECT COUNT(*)
     INTO n_bill_count
      FROM rebate_bill rb
     WHERE rb."start_time" = t_start_time
       AND rb.lssuing_state <> 'pending_pay';

    IF n_bill_count = 0 THEN
      DELETE FROM rebate_agent_api ra WHERE ra.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE "start_time" = t_start_time);
      DELETE FROM rebate_player_fee rp WHERE rp.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE "start_time" = t_start_time);
      DELETE FROM rebate_agent ra WHERE ra.rebate_bill_id IN (SELECT "id" FROM rebate_bill WHERE "start_time" = t_start_time);
      DELETE FROM rebate_bill rb WHERE "id" IN (SELECT "id" FROM rebate_bill WHERE "start_time" = t_start_time);
    ELSE
      raise notice '已生成本期返佣账单，无需重新生成。';
      RETURN 1;
    END IF;
  ELSEIF p_settle_flag = 'N' THEN
    TRUNCATE TABLE rebate_agent_api_nosettled;
    TRUNCATE TABLE rebate_player_fee_nosettled;
    TRUNCATE TABLE rebate_agent_nosettled;
    TRUNCATE TABLE rebate_bill_nosettled;
  END IF;

  raise notice '开始统计第( % )期的返佣【%】, 周期( % - % )', p_period, p_settle_flag, p_start_time, p_end_time;

  raise notice '返佣rebate_bill新增记录';
  SELECT gb_rebate_bill(n_rebate_bill_id, p_period, t_start_time, t_end_time, 'I', p_settle_flag) INTO n_rebate_bill_id;

  raise notice '统计代理API返佣信息';
  perform gb_rebate_agent_api(n_rebate_bill_id, t_start_time, t_end_time, p_settle_flag);

  raise notice '统计玩家费用';
  perform gb_rebate_player_fee(n_rebate_bill_id, t_start_time, t_end_time, p_settle_flag);

  raise notice '统计代理返佣';
  perform gb_rebate_agent(n_rebate_bill_id, t_start_time, t_end_time, p_settle_flag);

  raise notice '更新返佣总表';
  perform gb_rebate_bill(n_rebate_bill_id, p_period, t_start_time, t_end_time, 'U', p_settle_flag);

  RETURN 0;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_rebate(p_period text, p_start_time text, p_end_time text, p_settle_flag text)
IS 'Leisure-返佣结算账单-入口（新）';


DROP FUNCTION IF EXISTS gb_rebate_bill( INT, TEXT, TIMESTAMP, TIMESTAMP, TEXT, TEXT);
CREATE OR REPLACE FUNCTION gb_rebate_bill(
  p_bill_id  INOUT  INT,
  p_period    TEXT,
  p_start_time    TIMESTAMP,
  p_end_time    TIMESTAMP,
  p_operation    TEXT,
  p_flag    TEXT
)
RETURNS INT as $$

DECLARE
  rec     record;
  n_rebate_count    INT:=0; -- rebate_agent 条数

BEGIN
  IF p_flag='Y' THEN   --已出帐

    IF p_operation='I' THEN
      INSERT INTO rebate_bill (
        period, start_time, end_time,
        rebate_total, rebate_actual, agent_count, agent_lssuing_count, agent_reject_count,
        create_time, lssuing_state
      ) VALUES (
        p_period, p_start_time, p_end_time,
        0, 0, 0, 0, 0,
        clock_timestamp(), 'pending_pay'
      ) returning id into p_bill_id;

      raise notice 'rebate_bill.完成.Y键值:%', p_bill_id;

    ELSEIF p_operation='U' THEN

      SELECT COUNT(1) FROM rebate_agent WHERE rebate_bill_id = p_bill_id AND settlement_state = 'pending_lssuing' INTO n_rebate_count;

      IF n_rebate_count = 0 THEN
        --DELETE FROM rebate_bill WHERE id = p_bill_id;
        UPDATE rebate_bill SET lssuing_state = 'all_pay' WHERE id = p_bill_id;
      ELSE

        SELECT COUNT(agent_id)      agent_num,
               SUM(effective_self)  effective_transaction,
               SUM(profit_self)     profit_loss,
               SUM(rebate_total)    rebate_total
          FROM rebate_agent
         WHERE rebate_bill_id = p_bill_id
           AND settlement_state = 'pending_lssuing'
          INTO rec;

        UPDATE rebate_bill
           SET agent_count = rec.agent_num,
               effective_transaction = rec.effective_transaction,
               profit_loss = rec.profit_loss,
               rebate_total = rec.rebate_total,
               last_operate_time = clock_timestamp()
         WHERE id = p_bill_id;
      END IF;
    END IF;

  ELSEIF p_flag = 'N' THEN   --未出帐
    IF p_operation='I' THEN
      INSERT INTO rebate_bill_nosettled (
        period, start_time, end_time,
        rebate_total, agent_count,
        create_time
      ) VALUES (
        p_period, p_start_time, p_end_time,
        0, 0,
        clock_timestamp()
      ) returning id into p_bill_id;

      raise notice 'rebate_bill_nosettled.完成.N键值:%', p_bill_id;

    ELSEIF p_operation='U' THEN

      SELECT COUNT(1) FROM rebate_agent_nosettled WHERE rebate_bill_id = p_bill_id INTO n_rebate_count;
      IF n_rebate_count = 0 THEN
        NULL;
      ELSE

        SELECT COUNT(agent_id)      agent_num,
               SUM(effective_self)  effective_transaction,
               SUM(profit_self)     profit_loss,
               SUM(rebate_total)    rebate_total
          FROM rebate_agent_nosettled
         WHERE rebate_bill_id = p_bill_id
          INTO rec;

        UPDATE rebate_bill_nosettled
           SET agent_count = rec.agent_num,
               effective_transaction = rec.effective_transaction,
               profit_loss = rec.profit_loss,
               rebate_total = rec.rebate_total,
               last_operate_time = clock_timestamp()
         WHERE id = p_bill_id;

        --DELETE FROM rebate_bill_nosettled WHERE id <> p_bill_id;
      END IF;
    END IF;
  END IF;

  RETURN;

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_rebate_bill( p_bill_id INT, p_period TEXT, p_start_time TIMESTAMP, p_end_time TIMESTAMP, p_operation TEXT, p_flag TEXT)
IS 'Leisure-返佣结算账单.返佣主表';


DROP FUNCTION IF EXISTS gb_rebate_agent_api(INT, TIMESTAMP, TIMESTAMP, TEXT);
CREATE OR REPLACE FUNCTION gb_rebate_agent_api(
  p_bill_id   INT,
  p_start_time   TIMESTAMP,
  p_end_time   TIMESTAMP,
  p_settle_flag   TEXT
) RETURNS VOID AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/10/08  Leisure  创建此函数: 返佣结算账单.代理API返佣
--v1.00  2017/07/31  Leisure  增加多级代理返佣支持

*/
DECLARE

BEGIN

  raise notice 'gb_rebate_agent_api.BEGIN: %', clock_timestamp();

  IF p_settle_flag = 'Y' THEN

    --生成代理API返佣表数据
    WITH
    a_grad --得到返佣梯度
    AS (
      SELECT ouur.*, rg.id rebate_grads_id, rg.total_profit, rg.valid_player_num, rg.max_rebate
      FROM
      (
        SELECT oa.*, rs.id rebate_set_id, rgs.id rebate_grads_set_id, rgs.valid_value,
               ( SELECT COUNT(1)
                   FROM (
                          SELECT player_id
                            FROM operate_player
                           WHERE static_time >= p_start_time
                             AND static_time_end <= p_end_time
                             AND agent_id = ANY(oa.agent_array)
                           GROUP BY player_id
                          HAVING SUM(effective_transaction) >= rgs.valid_value
                        ) t
               ) effective_player  --获得有效玩家数
        FROM
        (
          SELECT ua.agent_rank, ua.id agent_id, su.username agent_name, ua.parent_id, ua.parent_array, array_agg( DISTINCT uas.id) agent_array,
                 SUM(oas.effective_transaction) effective_transaction,
                 -SUM(oas.profit_loss) profit_loss
            FROM user_agent ua
                   INNER JOIN
                 sys_user su ON su.user_type = '23' AND ua.id = su.id
                   INNER JOIN
                 user_agent uas ON ua.id = uas.id OR ARRAY[ua.id] <@ uas.parent_array --获得ua下面所有代理，包括自己
                   RIGHT JOIN
                 operate_agent oas ON oas.agent_id = uas.id
           WHERE oas.static_time >= p_start_time
             AND oas.static_time_end <= p_end_time
           GROUP BY ua.agent_rank, ua.id, su.username, ua.parent_id
           ORDER BY ua.agent_rank DESC, ua.id, su.username, ua.parent_id
          ) oa
          LEFT JOIN user_agent_rebate uar ON oa.agent_id = uar.user_id
          LEFT JOIN rebate_set rs ON uar.rebate_id = rs.id
          LEFT JOIN rebate_grads_set rgs ON rs.rebate_grads_set_id = rgs.id
      ) ouur
        LEFT JOIN rebate_grads rg ON rg.id = ( SELECT rg.id AS grads_id   --返佣梯度ID
                                                 FROM rebate_grads rg
                                                WHERE rg.rebate_grads_set_id = ouur.rebate_grads_set_id
                                                  AND ouur.profit_loss >= rg.total_profit --实际盈亏 >= 梯度盈亏
                                                  AND ouur.effective_player >= rg.valid_player_num --有效玩家数 >= 梯度玩家数
                                                ORDER BY rg.total_profit DESC, rg.valid_player_num DESC
                                                LIMIT 1
                                              )
    ),
    oat --得到各API各游戏有效交易量和返佣比率
    AS (
      SELECT ua.agent_rank, ua.id agent_id, su.username agent_name, ua.parent_id, array_agg( DISTINCT uas.id) agent_array, oas.api_id, oas.game_type,
             SUM(oas.effective_transaction) effective_transaction,
             -SUM(oas.profit_loss) profit_loss
        FROM user_agent ua
               INNER JOIN
             sys_user su ON su.user_type = '23' AND ua.id = su.id
               INNER JOIN
             user_agent uas ON ua.id = uas.id OR ARRAY[ua.id] <@ uas.parent_array
               RIGHT JOIN
             operate_agent oas ON oas.agent_id = uas.id
       WHERE oas.static_time >= p_start_time
         AND oas.static_time_end <= p_end_time
       GROUP BY ua.agent_rank, ua.id, su.username, ua.parent_id, oas.api_id, oas.game_type
       --ORDER BY ua.agent_rank DESC, ua.id, su.username, ua.parent_id, oas.api_id, oas.game_type
    ),
    rat AS (
      SELECT a_grad.agent_id,
             a_grad.agent_name,
             a_grad.agent_rank,
             a_grad.parent_id,
             a_grad.parent_array,
             a_grad.rebate_set_id,
             a_grad.rebate_grads_set_id,
             a_grad.rebate_grads_id,
             a_grad.effective_player,
             a_grad.max_rebate,
             oat.api_id,
             oat.game_type,
             oat.agent_array,
             oat.effective_transaction,
             oat.profit_loss,
             rga.ratio rebate_ratio
        FROM oat
               INNER JOIN
             a_grad ON oat.agent_id = a_grad.agent_id
               LEFT JOIN
             rebate_grads_api rga ON rga.id = ( SELECT id
                                                  FROM rebate_grads_api
                                                 WHERE rebate_grads_id = a_grad.rebate_grads_id
                                                   AND rebate_set_id = a_grad.rebate_set_id
                                                   AND api_id = oat.api_id
                                                   AND game_type = oat.game_type
                                              )
    ),
    rats --得到自身有效交易量、盈亏
    AS (
    SELECT rat.*,
           rga.ratio parent_ratio,
           oa.effective_transaction effective_self,
           oa.profit_loss profit_self
      FROM rat
             LEFT JOIN
           user_agent_rebate uar ON rat.parent_id = uar.user_id AND rat.agent_rank > 1 -- 一级代理不需要计算上级抽佣！！！！
             LEFT JOIN
           rebate_grads_api rga ON rga.rebate_grads_id = rat.rebate_grads_id
                               AND rga.rebate_set_id = uar.rebate_id
                               AND rga.api_id = rat.api_id
                               AND rga.game_type = rat.game_type
             LEFT JOIN
           (
             SELECT agent_id, api_id, game_type, SUM(effective_transaction) effective_transaction, -SUM(profit_loss) profit_loss
              FROM operate_agent
             WHERE static_time >= p_start_time
               AND static_time_end <= p_end_time
             GROUP BY agent_id, api_id, game_type
           ) oa ON rat.agent_id = oa.agent_id AND rat.api_id = oa.api_id AND rat.game_type= oa.game_type
    )
    INSERT INTO rebate_agent_api (
           rebate_bill_id, agent_id, agent_name, agent_rank, parent_id, rebate_set_id, rebate_grads_id, max_rebate, effective_player,
           api_id, game_type, agent_array, effective_transaction, profit_loss, rebate_ratio, parent_ratio,
           rebate_parent, effective_self, profit_self, rebate_self
    )
    SELECT p_bill_id, agent_id, agent_name, agent_rank, parent_id, rebate_set_id, rebate_grads_id, max_rebate, effective_player,
           api_id, game_type, agent_array, effective_transaction, profit_loss, rebate_ratio, parent_ratio,
           profit_loss * (parent_ratio-rebate_ratio)/100 rebate_parent,
         effective_self, profit_self,
         profit_self * rebate_ratio/100 rebate_self
    FROM rats;

    --更新字段: 下级代理贡献佣金
    UPDATE rebate_agent_api raa
       SET rebate_sun = COALESCE(raa2.rebate_parent, 0)
      FROM
      ( SELECT * FROM rebate_agent_api WHERE rebate_bill_id = p_bill_id
      ) raa1
      LEFT JOIN
      ( SELECT parent_id, api_id, game_type, SUM(rebate_parent) rebate_parent
          FROM rebate_agent_api
         WHERE rebate_bill_id = p_bill_id
         GROUP BY parent_id, api_id, game_type
      ) raa2
      ON raa1.agent_id = raa2.parent_id
        AND raa1.api_id = raa2.api_id
        AND raa1.game_type = raa2.game_type
     WHERE raa.rebate_bill_id = p_bill_id
       AND raa.agent_id = raa1.agent_id
       AND raa.api_id = raa1.api_id
       AND raa.game_type = raa1.game_type;


  ELSEIF p_settle_flag = 'N' THEN

    --生成代理API返佣表数据
    WITH
    a_grad --得到返佣梯度
    AS (
      SELECT ouur.*, rg.id rebate_grads_id, rg.total_profit, rg.valid_player_num, rg.max_rebate
      FROM
      (
        SELECT oa.*, rs.id rebate_set_id, rgs.id rebate_grads_set_id, rgs.valid_value,
               ( SELECT COUNT(1)
                   FROM (
                          SELECT player_id
                            FROM operate_player
                           WHERE static_time >= p_start_time
                             AND static_time_end <= p_end_time
                             AND agent_id = ANY(oa.agent_array)
                           GROUP BY player_id
                          HAVING SUM(effective_transaction) >= rgs.valid_value
                        ) t
               ) effective_player  --获得有效玩家数
        FROM
        (
          SELECT ua.agent_rank, ua.id agent_id, su.username agent_name, ua.parent_id, ua.parent_array, array_agg( DISTINCT uas.id) agent_array,
                 SUM(oas.effective_transaction) effective_transaction,
                 -SUM(oas.profit_loss) profit_loss
            FROM user_agent ua
                   INNER JOIN
                 sys_user su ON su.user_type = '23' AND ua.id = su.id
                   INNER JOIN
                 user_agent uas ON ua.id = uas.id OR ARRAY[ua.id] <@ uas.parent_array --获得ua下面所有代理，包括自己
                   RIGHT JOIN
                 operate_agent oas ON oas.agent_id = uas.id
           WHERE oas.static_time >= p_start_time
             AND oas.static_time_end <= p_end_time
           GROUP BY ua.agent_rank, ua.id, su.username, ua.parent_id
           ORDER BY ua.agent_rank DESC, ua.id, su.username, ua.parent_id
          ) oa
          LEFT JOIN user_agent_rebate uar ON oa.agent_id = uar.user_id
          LEFT JOIN rebate_set rs ON uar.rebate_id = rs.id
          LEFT JOIN rebate_grads_set rgs ON rs.rebate_grads_set_id = rgs.id
      ) ouur
        LEFT JOIN rebate_grads rg ON rg.id = ( SELECT rg.id AS grads_id   --返佣梯度ID
                                                 FROM rebate_grads rg
                                                WHERE rg.rebate_grads_set_id = ouur.rebate_grads_set_id
                                                  AND ouur.profit_loss >= rg.total_profit --实际盈亏 >= 梯度盈亏
                                                  AND ouur.effective_player >= rg.valid_player_num --有效玩家数 >= 梯度玩家数
                                                ORDER BY rg.total_profit DESC, rg.valid_player_num DESC
                                                LIMIT 1
                                              )
    ),
    oat --得到各API各游戏有效交易量和返佣比率
    AS (
      SELECT ua.agent_rank, ua.id agent_id, su.username agent_name, ua.parent_id, array_agg( DISTINCT uas.id) agent_array, oas.api_id, oas.game_type,
             SUM(oas.effective_transaction) effective_transaction,
             -SUM(oas.profit_loss) profit_loss
        FROM user_agent ua
               INNER JOIN
             sys_user su ON su.user_type = '23' AND ua.id = su.id
               INNER JOIN
             user_agent uas ON ua.id = uas.id OR ARRAY[ua.id] <@ uas.parent_array
               RIGHT JOIN
             operate_agent oas ON oas.agent_id = uas.id
       WHERE oas.static_time >= p_start_time
         AND oas.static_time_end <= p_end_time
       GROUP BY ua.agent_rank, ua.id, su.username, ua.parent_id, oas.api_id, oas.game_type
       --ORDER BY ua.agent_rank DESC, ua.id, su.username, ua.parent_id, oas.api_id, oas.game_type
    ),
    rat AS (
      SELECT a_grad.agent_id,
             a_grad.agent_name,
             a_grad.agent_rank,
             a_grad.parent_id,
             a_grad.parent_array,
             a_grad.rebate_set_id,
             a_grad.rebate_grads_set_id,
             a_grad.rebate_grads_id,
             a_grad.effective_player,
             a_grad.max_rebate,
             oat.api_id,
             oat.game_type,
             oat.agent_array,
             oat.effective_transaction,
             oat.profit_loss,
             rga.ratio rebate_ratio
        FROM oat
               INNER JOIN
             a_grad ON oat.agent_id = a_grad.agent_id
               LEFT JOIN
             rebate_grads_api rga ON rga.id = ( SELECT id
                                                  FROM rebate_grads_api
                                                 WHERE rebate_grads_id = a_grad.rebate_grads_id
                                                   AND rebate_set_id = a_grad.rebate_set_id
                                                   AND api_id = oat.api_id
                                                   AND game_type = oat.game_type
                                              )
    ),
    rats --得到自身有效交易量、盈亏
    AS (
    SELECT rat.*,
           rga.ratio parent_ratio,
           oa.effective_transaction effective_self,
           oa.profit_loss profit_self
      FROM rat
             LEFT JOIN
           user_agent_rebate uar ON rat.parent_id = uar.user_id AND rat.agent_rank > 1 -- 一级代理不需要计算上级抽佣！！！！
             LEFT JOIN
           rebate_grads_api rga ON rga.rebate_grads_id = rat.rebate_grads_id
                               AND rga.rebate_set_id = uar.rebate_id
                               AND rga.api_id = rat.api_id
                               AND rga.game_type = rat.game_type
             LEFT JOIN
           (
             SELECT agent_id, api_id, game_type, SUM(effective_transaction) effective_transaction, -SUM(profit_loss) profit_loss
              FROM operate_agent
             WHERE static_time >= p_start_time
               AND static_time_end <= p_end_time
             GROUP BY agent_id, api_id, game_type
           ) oa ON rat.agent_id = oa.agent_id AND rat.api_id = oa.api_id AND rat.game_type= oa.game_type
    )
    INSERT INTO rebate_agent_api_nosettled (
           rebate_bill_id, agent_id, agent_name, agent_rank, parent_id, rebate_set_id, rebate_grads_id, max_rebate, effective_player,
           api_id, game_type, agent_array, effective_transaction, profit_loss, rebate_ratio, parent_ratio,
           rebate_parent, effective_self, profit_self, rebate_self
    )
    SELECT p_bill_id, agent_id, agent_name, agent_rank, parent_id, rebate_set_id, rebate_grads_id, max_rebate, effective_player,
           api_id, game_type, agent_array, effective_transaction, profit_loss, rebate_ratio, parent_ratio,
           profit_loss * (parent_ratio-rebate_ratio)/100 rebate_parent,
         effective_self, profit_self,
         profit_self * rebate_ratio/100 rebate_self
    FROM rats;

    --更新字段: 下级代理贡献佣金
    UPDATE rebate_agent_api_nosettled raa
       SET rebate_sun = COALESCE(raa2.rebate_parent, 0)
      FROM
      ( SELECT * FROM rebate_agent_api_nosettled WHERE rebate_bill_id = p_bill_id
      ) raa1
      LEFT JOIN
      ( SELECT parent_id, api_id, game_type, SUM(rebate_parent) rebate_parent
          FROM rebate_agent_api_nosettled
         WHERE rebate_bill_id = p_bill_id
         GROUP BY parent_id, api_id, game_type
      ) raa2
      ON raa1.agent_id = raa2.parent_id
        AND raa1.api_id = raa2.api_id
        AND raa1.game_type = raa2.game_type
     WHERE raa.rebate_bill_id = p_bill_id
       AND raa.agent_id = raa1.agent_id
       AND raa.api_id = raa1.api_id
       AND raa.game_type = raa1.game_type;

  END IF;

  raise notice 'gb_rebate_agent_api.END: %', clock_timestamp();

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_rebate_agent_api(p_bill_id INT, p_start_time TIMESTAMP, p_end_time TIMESTAMP, p_settle_flag TEXT)
IS 'Leisure-返佣结算账单.代理API返佣';


DROP FUNCTION IF EXISTS gb_rebate_player_fee(INT, TIMESTAMP, TIMESTAMP, TEXT);
CREATE OR REPLACE FUNCTION gb_rebate_player_fee(
  p_bill_id   INT,
  p_start_time   TIMESTAMP,
  p_end_time   TIMESTAMP,
  p_settle_flag   TEXT
) RETURNS VOID AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/07/31  Leisure  创建此函数: 返佣结算账单.玩家费用

*/
DECLARE

BEGIN
  IF p_settle_flag = 'Y' THEN

    WITH
      pt AS (
        SELECT *
          FROM player_transaction
         WHERE status = 'success'
           AND completion_time >= p_start_time
           AND completion_time < p_end_time
      ),

      pti AS (
        --存款
         SELECT player_id,
                'deposit' AS transaction_type,
                transaction_money
           FROM pt
          WHERE transaction_type = 'deposit'

         UNION ALL
         --取款
         SELECT player_id,
                'withdrawal' AS transaction_type,
                -transaction_money AS transaction_money  --取款金额是负值
           FROM pt
          WHERE transaction_type = 'withdrawals'

         UNION ALL
         --返水
         SELECT player_id,
                'backwater' AS transaction_type,
                transaction_money
           FROM pt
          --WHERE ( transaction_type = 'backwater' OR
          --        (transaction_type = 'favorable' AND transaction_way = 'manual_rakeback'))
          WHERE transaction_type = 'backwater'

         UNION ALL
         --优惠
         SELECT player_id,
                'favorable' AS transaction_type,
                transaction_money
           FROM pt
          --WHERE ( ( transaction_type = 'favorable'
          --          AND transaction_way <> 'manual_rakeback') OR
          --        transaction_type = 'recommend')
          WHERE ( transaction_type = 'favorable' OR transaction_type = 'recommend')

      ),

      pto AS (
        SELECT player_id,
               SUM(CASE transaction_type WHEN 'deposit' THEN transaction_money ELSE 0 END) AS deposit_amount,
               SUM(CASE transaction_type WHEN 'withdrawal' THEN transaction_money ELSE 0 END) AS withdraw_amount,
               SUM(CASE transaction_type WHEN 'backwater' THEN transaction_money ELSE 0 END) AS rakeback_amount,
               SUM(CASE transaction_type WHEN 'favorable' THEN transaction_money ELSE 0 END) AS favorable_amount,
               0 AS other_amount
          FROM pti
         GROUP BY player_id
      ),

      ptu AS (
        SELECT pto.*,
               su.username player_name,
               ua.id agent_id,
               ua.username agent_name,
               ut.id topagent_id,
               ut.username topagent_name
          FROM pto
               LEFT JOIN
               sys_user su ON pto.player_id = su."id" AND su.user_type = '24'
               LEFT JOIN
               sys_user ua ON su.owner_id = ua."id" AND ua.user_type = '23'
               LEFT JOIN
               sys_user ut ON ua.owner_id = ut."id" AND ua.user_type = '22'
      )

      INSERT INTO rebate_player_fee ( rebate_bill_id, topagent_id, topagent_name, agent_id, agent_name, player_id, player_name,
          deposit_amount, withdraw_amount, rakeback_amount, favorable_amount, other_amount
      ) SELECT p_bill_id, topagent_id, topagent_name, agent_id, agent_name, player_id, player_name,
          deposit_amount, withdraw_amount, rakeback_amount, favorable_amount, other_amount
      FROM ptu;


  ELSEIF p_settle_flag = 'N' THEN

    WITH
      pt AS (
        SELECT *
          FROM player_transaction
         WHERE status = 'success'
           AND completion_time >= p_start_time
           AND completion_time < p_end_time
      ),

      pti AS (
        --存款
         SELECT player_id,
                'deposit' AS transaction_type,
                transaction_money
           FROM pt
          WHERE transaction_type = 'deposit'

         UNION ALL
         --取款
         SELECT player_id,
                'withdrawal' AS transaction_type,
                -transaction_money AS transaction_money
           FROM pt
          WHERE transaction_type = 'withdrawals'

         UNION ALL
         --返水
         SELECT player_id,
                'backwater' AS transaction_type,
                transaction_money
           FROM pt
          --WHERE ( transaction_type = 'backwater' OR
          --        (transaction_type = 'favorable' AND transaction_way = 'manual_rakeback'))
          WHERE transaction_type = 'backwater'

         UNION ALL
         --优惠
         SELECT player_id,
                'favorable' AS transaction_type,
                transaction_money
           FROM pt
          --WHERE ( ( transaction_type = 'favorable'
          --          AND transaction_way <> 'manual_rakeback') OR
          --        transaction_type = 'recommend')
          WHERE ( transaction_type = 'favorable' OR transaction_type = 'recommend')

      ),

      pto AS (
        SELECT player_id,
               SUM(CASE transaction_type WHEN 'deposit' THEN transaction_money ELSE 0 END) AS deposit_amount,
               SUM(CASE transaction_type WHEN 'withdrawal' THEN transaction_money ELSE 0 END) AS withdraw_amount,
               SUM(CASE transaction_type WHEN 'backwater' THEN transaction_money ELSE 0 END) AS rakeback_amount,
               SUM(CASE transaction_type WHEN 'favorable' THEN transaction_money ELSE 0 END) AS favorable_amount,
               0 AS other_amount
          FROM pti
         GROUP BY player_id
      ),

      ptu AS (
        SELECT pto.*,
               su.username player_name,
               ua.id agent_id,
               ua.username agent_name,
               ut.id topagent_id,
               ut.username topagent_name
          FROM pto
               LEFT JOIN
               sys_user su ON pto.player_id = su."id" AND su.user_type = '24'
               LEFT JOIN
               sys_user ua ON su.owner_id = ua."id" AND ua.user_type = '23'
               LEFT JOIN
               sys_user ut ON ua.owner_id = ut."id" AND ua.user_type = '22'
      )

      INSERT INTO rebate_player_fee_nosettled ( rebate_bill_id, topagent_id, topagent_name, agent_id, agent_name, player_id, player_name,
          deposit_amount, withdraw_amount, rakeback_amount, favorable_amount, other_amount
      ) SELECT p_bill_id, topagent_id, topagent_name, agent_id, agent_name, player_id, player_name,
          deposit_amount, withdraw_amount, rakeback_amount, favorable_amount, other_amount
      FROM ptu;

  END IF;
END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_rebate_player_fee( p_bill_id INT, p_start_time TIMESTAMP, p_end_time TIMESTAMP, p_settle_flag TEXT)
IS 'Leisure-返佣结算账单.玩家费用';


DROP FUNCTION IF EXISTS gb_rebate_agent(INT, TIMESTAMP, TIMESTAMP, TEXT);
CREATE OR REPLACE FUNCTION gb_rebate_agent(
  p_bill_id   INT,
  p_start_time   TIMESTAMP,
  p_end_time   TIMESTAMP,
  p_settle_flag   TEXT
) RETURNS VOID AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2016/10/08  Leisure  创建此函数: 返佣结算账单.代理返佣
--v1.00  2017/07/31  Leisure  增加多级代理返佣支持

*/
DECLARE

  d_last_start_time TIMESTAMP;

  n_deposit_radio   FLOAT := 0;
  n_withdraw_radio  FLOAT := 0;
  n_rakeback_radio  FLOAT := 0;
  n_favorable_radio FLOAT := 0;
  n_other_radio     FLOAT := 0;

  h_param_array  hstore;

BEGIN

  SELECT string_agg(hstore(param_code, param_value)::TEXT, ',')::hstore
    FROM (SELECT param_code, param_value FROM sys_param WHERE param_type = 'apportionSetting' OR param_type = 'rebateSetting' ORDER BY 1) sp
    INTO h_param_array;

  n_deposit_radio := COALESCE(h_param_array ->'settlement.deposit.fee', '0')::FLOAT;
  n_withdraw_radio := COALESCE(h_param_array ->'settlement.withdraw.fee', '0')::FLOAT;
  n_rakeback_radio := COALESCE(h_param_array ->'agent.rakeback.percent', '0')::FLOAT;
  n_favorable_radio := COALESCE(h_param_array ->'agent.preferential.percent', '0')::FLOAT;
  n_other_radio := COALESCE(h_param_array ->'agent.other.percent', '0')::FLOAT;

  d_last_start_time := p_start_time + '1 day' + '-1 month' + '-1 day'; -- 加一天防止是月末日期，再取上个月。

  raise notice 'gb_rebate_agent.BEGIN: %', clock_timestamp();

  IF p_settle_flag = 'Y' THEN

    WITH
    ua AS --代理信息
    (
      SELECT ua.agent_rank, ua.id agent_id, su.username agent_name, ua.parent_id, ua.parent_array, uar.id rebate_set_id
        FROM user_agent ua
               INNER JOIN
             sys_user su ON su.user_type = '23' AND ua.id = su.id
               LEFT JOIN user_agent_rebate uar ON ua.id = uar.user_id
       WHERE su.status IN ('1', '2', '3')
    ),

    raa AS --本期返佣信息
    (
      SELECT agent_id,
             MIN(rebate_grads_id) rebate_grads_id,
             MIN(max_rebate) max_rebate,
             MIN(effective_player) effective_player,
             SUM(effective_transaction) effective_transaction,
             SUM(profit_loss) profit_loss,
             SUM(rebate_parent) rebate_parent,
             SUM(effective_self) effective_self,
             SUM(profit_self) profit_self,
             SUM(rebate_self) rebate_self,
             SUM(rebate_sun) rebate_sun
        FROM rebate_agent_api
       WHERE rebate_bill_id = p_bill_id
       GROUP BY agent_id
    ),

    rpf AS --分摊费用
    (
      SELECT agent_id,
             SUM(deposit_amount) AS deposit_amount,
             n_deposit_radio AS deposit_radio,
             SUM(deposit_amount) * n_deposit_radio/100 AS deposit_fee,

             SUM(withdraw_amount) AS withdraw_amount,
             n_withdraw_radio AS withdraw_radio,
             SUM(withdraw_amount)*n_withdraw_radio/100 AS withdraw_fee,

             SUM(rakeback_amount) AS rakeback_amount,
             n_rakeback_radio AS rakeback_radio,
             SUM(rakeback_amount) * n_rakeback_radio/100 AS rakeback_fee,

             SUM(favorable_amount) AS favorable_amount,
             n_favorable_radio AS favorable_radio,
             SUM(favorable_amount) * n_favorable_radio/100 AS favorable_fee,

             SUM(other_amount) AS other_amount,
             n_other_radio AS other_radio,
             SUM(other_amount) * n_other_radio/100 AS other_fee

        FROM rebate_player_fee
       WHERE rebate_bill_id = p_bill_id
       GROUP BY agent_id
    ),

    rah AS --上期返佣信息
    (
      SELECT agent_id,
             rebate_self + rebate_self_history AS rebate_self_history,
             rebate_sun + rebate_sun_history AS rebate_sun_history,
             fee_amount + fee_history AS fee_history
        FROM rebate_agent
       WHERE rebate_bill_id = (SELECT id FROM rebate_bill WHERE start_time = d_last_start_time)
         AND settlement_state = 'next_lssuing'
    ),

    rai AS
    (
      SELECT ua.agent_id, ua.agent_name, ua.agent_rank, ua.parent_id, ua.parent_array, ua.rebate_set_id,
             raa.rebate_grads_id, raa.max_rebate, raa.effective_player, raa.effective_transaction, raa.profit_loss, raa.rebate_parent,
             raa.effective_self, raa.profit_self,
             raa.rebate_self, rah.rebate_self_history, raa.rebate_sun, rah.rebate_sun_history,
             rpf.deposit_amount, rpf.deposit_radio, rpf.deposit_fee,
             rpf.withdraw_amount, rpf.withdraw_radio, rpf.withdraw_fee, rpf.rakeback_amount, rpf.rakeback_radio, rpf.rakeback_fee,
             rpf.favorable_amount, rpf.favorable_radio, rpf.favorable_fee, rpf.other_amount, rpf.other_radio, rpf.other_fee,
             rpf.deposit_fee + rpf.withdraw_fee + rpf.rakeback_fee + rpf.favorable_fee + rpf.other_fee AS fee_amount,
             rah.fee_history
        FROM ua
            LEFT JOIN
          raa ON ua.agent_id = raa.agent_id
            LEFT JOIN
          rpf ON ua.agent_id = rpf.agent_id
            LEFT JOIN
          rah ON ua.agent_id = rah.agent_id
    )

    INSERT INTO rebate_agent ( rebate_bill_id, agent_id, agent_name, agent_rank, parent_id, parent_array, rebate_set_id,
        rebate_grads_id, max_rebate, effective_player, effective_transaction, profit_loss, rebate_parent, effective_self, profit_self,
        rebate_self, rebate_self_history, rebate_sun, rebate_sun_history, deposit_amount, deposit_radio, deposit_fee,
        withdraw_amount, withdraw_radio, withdraw_fee, rakeback_amount, rakeback_radio, rakeback_fee,
        favorable_amount, favorable_radio, favorable_fee, other_amount, other_radio, other_fee, fee_amount, fee_history,
        rebate_total, rebate_actual, settlement_state
    )
    SELECT p_bill_id, agent_id, agent_name, agent_rank, parent_id, parent_array, rebate_set_id,
           rebate_grads_id, max_rebate, COALESCE(effective_player, 0), COALESCE(effective_transaction, 0), COALESCE(profit_loss, 0), COALESCE(rebate_parent, 0), COALESCE(effective_self, 0), COALESCE(profit_self, 0),
           COALESCE(rebate_self, 0), COALESCE(rebate_self_history, 0), COALESCE(rebate_sun, 0), COALESCE(rebate_sun_history, 0), COALESCE(deposit_amount, 0), COALESCE(deposit_radio, 0), COALESCE(deposit_fee, 0),
           COALESCE(withdraw_amount, 0), COALESCE(withdraw_radio, 0), COALESCE(withdraw_fee, 0), COALESCE(rakeback_amount, 0), COALESCE(rakeback_radio, 0), COALESCE(rakeback_fee, 0),
           COALESCE(favorable_amount, 0), COALESCE(favorable_radio, 0), COALESCE(favorable_fee, 0), COALESCE(other_amount, 0), COALESCE(other_radio, 0), COALESCE(other_fee, 0), COALESCE(fee_amount, 0), COALESCE(fee_history, 0),
           COALESCE(rebate_self, 0) + COALESCE(rebate_self_history , 0)
           + COALESCE(rebate_sun , 0) + COALESCE(rebate_sun_history , 0) - COALESCE(fee_amount , 0) - COALESCE(fee_history, 0) AS rebate_total,
           0 AS rebate_actual,
           'pending_lssuing'
      FROM rai
     WHERE ( COALESCE(effective_transaction, 0) <> 0 OR COALESCE(profit_loss, 0) <> 0 OR
             COALESCE(rebate_self, 0) <> 0 OR COALESCE(rebate_self_history , 0) <> 0 OR COALESCE(rebate_sun , 0) <> 0 OR
             COALESCE(rebate_sun_history , 0) <> 0 OR COALESCE(fee_amount , 0) <> 0 OR COALESCE(fee_history, 0) <> 0
           );


  ELSEIF p_settle_flag = 'N' THEN

    WITH
    ua AS --代理信息
    (
      SELECT ua.agent_rank, ua.id agent_id, su.username agent_name, ua.parent_id, ua.parent_array, uar.id rebate_set_id
        FROM user_agent ua
               INNER JOIN
             sys_user su ON su.user_type = '23' AND ua.id = su.id
               LEFT JOIN user_agent_rebate uar ON ua.id = uar.user_id
       WHERE su.status IN ('1', '2', '3')
    ),

    raa AS --本期返佣信息
    (
      SELECT agent_id,
             MIN(rebate_grads_id) rebate_grads_id,
             MIN(max_rebate) max_rebate,
             MIN(effective_player) effective_player,
             SUM(effective_transaction) effective_transaction,
             SUM(profit_loss) profit_loss,
             SUM(rebate_parent) rebate_parent,
             SUM(effective_self) effective_self,
             SUM(profit_self) profit_self,
             SUM(rebate_self) rebate_self,
             SUM(rebate_sun) rebate_sun
        FROM rebate_agent_api_nosettled
       WHERE rebate_bill_id = p_bill_id
       GROUP BY agent_id
    ),

    rpf AS --分摊费用
    (
      SELECT agent_id,
             SUM(deposit_amount) AS deposit_amount,
             n_deposit_radio AS deposit_radio,
             SUM(deposit_amount) * n_deposit_radio/100 AS deposit_fee,

             SUM(withdraw_amount) AS withdraw_amount,
             n_withdraw_radio AS withdraw_radio,
             SUM(withdraw_amount)*n_withdraw_radio/100 AS withdraw_fee,

             SUM(rakeback_amount) AS rakeback_amount,
             n_rakeback_radio AS rakeback_radio,
             SUM(rakeback_amount) * n_rakeback_radio/100 AS rakeback_fee,

             SUM(favorable_amount) AS favorable_amount,
             n_favorable_radio AS favorable_radio,
             SUM(favorable_amount) * n_favorable_radio/100 AS favorable_fee,

             SUM(other_amount) AS other_amount,
             n_other_radio AS other_radio,
             SUM(other_amount) * n_other_radio/100 AS other_fee

        FROM rebate_player_fee_nosettled
       WHERE rebate_bill_id = p_bill_id
       GROUP BY agent_id
    ),

    rah AS --上期返佣信息
    (
      SELECT agent_id,
             rebate_self + rebate_self_history AS rebate_self_history,
             rebate_sun + rebate_sun_history AS rebate_sun_history,
             fee_amount + fee_history AS fee_history
        FROM rebate_agent
       WHERE rebate_bill_id = (SELECT id FROM rebate_bill WHERE start_time = d_last_start_time)
         AND settlement_state = 'next_lssuing'
    ),

    rai AS
    (
      SELECT ua.agent_id, ua.agent_name, ua.agent_rank, ua.parent_id, ua.parent_array, ua.rebate_set_id,
             raa.rebate_grads_id, raa.max_rebate, raa.effective_player, raa.effective_transaction, raa.profit_loss, raa.rebate_parent,
             raa.effective_self, raa.profit_self,
             raa.rebate_self, rah.rebate_self_history, raa.rebate_sun, rah.rebate_sun_history,
             rpf.deposit_amount, rpf.deposit_radio, rpf.deposit_fee,
             rpf.withdraw_amount, rpf.withdraw_radio, rpf.withdraw_fee, rpf.rakeback_amount, rpf.rakeback_radio, rpf.rakeback_fee,
             rpf.favorable_amount, rpf.favorable_radio, rpf.favorable_fee, rpf.other_amount, rpf.other_radio, rpf.other_fee,
             rpf.deposit_fee + rpf.withdraw_fee + rpf.rakeback_fee + rpf.favorable_fee + rpf.other_fee AS fee_amount,
             rah.fee_history
        FROM ua
            LEFT JOIN
          raa ON ua.agent_id = raa.agent_id
            LEFT JOIN
          rpf ON ua.agent_id = rpf.agent_id
            LEFT JOIN
          rah ON ua.agent_id = rah.agent_id
    )

    INSERT INTO rebate_agent_nosettled ( rebate_bill_id, agent_id, agent_name, agent_rank, parent_id, parent_array, rebate_set_id,
        rebate_grads_id, max_rebate, effective_player, effective_transaction, profit_loss, rebate_parent, effective_self, profit_self,
        rebate_self, rebate_self_history, rebate_sun, rebate_sun_history, deposit_amount, deposit_radio, deposit_fee,
        withdraw_amount, withdraw_radio, withdraw_fee, rakeback_amount, rakeback_radio, rakeback_fee,
        favorable_amount, favorable_radio, favorable_fee, other_amount, other_radio, other_fee, fee_amount, fee_history,
        rebate_total
    )
    SELECT p_bill_id, agent_id, agent_name, agent_rank, parent_id, parent_array, rebate_set_id,
           rebate_grads_id, max_rebate, COALESCE(effective_player, 0), COALESCE(effective_transaction, 0), COALESCE(profit_loss, 0), COALESCE(rebate_parent, 0), COALESCE(effective_self, 0), COALESCE(profit_self, 0),
           COALESCE(rebate_self, 0), COALESCE(rebate_self_history, 0), COALESCE(rebate_sun, 0), COALESCE(rebate_sun_history, 0), COALESCE(deposit_amount, 0), COALESCE(deposit_radio, 0), COALESCE(deposit_fee, 0),
           COALESCE(withdraw_amount, 0), COALESCE(withdraw_radio, 0), COALESCE(withdraw_fee, 0), COALESCE(rakeback_amount, 0), COALESCE(rakeback_radio, 0), COALESCE(rakeback_fee, 0),
           COALESCE(favorable_amount, 0), COALESCE(favorable_radio, 0), COALESCE(favorable_fee, 0), COALESCE(other_amount, 0), COALESCE(other_radio, 0), COALESCE(other_fee, 0), COALESCE(fee_amount, 0), COALESCE(fee_history, 0),
           COALESCE(rebate_self, 0) + COALESCE(rebate_self_history , 0)
           + COALESCE(rebate_sun , 0) + COALESCE(rebate_sun_history , 0) - COALESCE(fee_amount , 0) - COALESCE(fee_history, 0) AS rebate_total
      FROM rai
     WHERE ( COALESCE(effective_transaction, 0) <> 0 OR COALESCE(profit_loss, 0) <> 0 OR
             COALESCE(rebate_self, 0) <> 0 OR COALESCE(rebate_self_history , 0) <> 0 OR COALESCE(rebate_sun , 0) <> 0 OR
             COALESCE(rebate_sun_history , 0) <> 0 OR COALESCE(fee_amount , 0) <> 0 OR COALESCE(fee_history, 0) <> 0
           );

  END IF;

  raise notice 'gb_rebate_agent.END: %', clock_timestamp();

END;

$$ language plpgsql;
COMMENT ON FUNCTION gb_rebate_agent(p_bill_id INT, p_start_time TIMESTAMP, p_end_time TIMESTAMP, p_settle_flag TEXT)
IS 'Leisure-返佣结算账单.代理返佣';