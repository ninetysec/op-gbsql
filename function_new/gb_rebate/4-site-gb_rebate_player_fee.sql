DROP FUNCTION IF EXISTS gb_rebate_player_fee(INT, TIMESTAMP, TIMESTAMP, TEXT);
CREATE OR REPLACE FUNCTION gb_rebate_player_fee(
  p_bill_id   INT,
  p_start_time   TIMESTAMP,
  p_end_time   TIMESTAMP,
  p_settle_flag   TEXT
) RETURNS VOID AS $$
/*版本更新说明
  版本   时间        作者     内容
--v1.00  2017/07/31  Laser    创建此函数: 返佣结算账单.玩家费用

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
IS 'Laser-返佣结算账单.玩家费用';
