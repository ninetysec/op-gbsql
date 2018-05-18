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
           user_agent_rebate uar ON rat.parent_id = uar.user_id AND rat.agent_rank > 1 -- 一级代理不需要计算上级抽佣！！！！否则会关联出多个总代方案！！！！
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
           user_agent_rebate uar ON rat.parent_id = uar.user_id AND rat.agent_rank > 1 -- 一级代理不需要计算上级抽佣！！！！否则会关联出多个总代方案！！！！
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
