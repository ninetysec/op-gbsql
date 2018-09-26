-- auto gen by steffan 2018-09-26 17:18:46
DROP FUNCTION IF EXISTS "gb_rebate_player_fee"(p_bill_id int4, p_start_time timestamp, p_end_time timestamp, p_settle_flag text);
CREATE OR REPLACE FUNCTION "gb_rebate_player_fee"(p_bill_id int4, p_start_time timestamp, p_end_time timestamp, p_settle_flag text)
  RETURNS "pg_catalog"."void" AS $BODY$
/*版本更新说明
  版本   时间        作者   内容
--v1.00  2017/07/31  Laser  创建此函数: 返佣结算账单.玩家费用
--v1.01  2018/01/01  Laser  修正一处bug
--v1.02  2018/06/06  Laser  增对代理线修改问题，代理改由流水表取

*/
DECLARE

BEGIN
  IF p_settle_flag = 'Y' THEN

    --v1.08  2018/06/06  Laser
    /*
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
               sys_user ut ON ua.owner_id = ut."id" AND ut.user_type = '22' --v1.01  2018/01/01  Laser
      )
    */
    WITH
      pt AS (
        SELECT player_id, user_name player_name, agent_id, agent_username agent_name, topagent_id, topagent_username topagent_name, transaction_type, SUM(transaction_money) transaction_money
          FROM player_transaction
         WHERE status = 'success'
           AND completion_time >= p_start_time
           AND completion_time < p_end_time
           AND transaction_type IN ( 'deposit', 'withdrawals', 'backwater', 'favorable', 'recommend')
         GROUP BY player_id, user_name, agent_id, agent_username, topagent_id, topagent_username, transaction_type
      ),

      ptu AS (
        SELECT player_id, player_name, agent_id, agent_name, topagent_id, topagent_name,
               SUM(CASE transaction_type WHEN 'deposit' THEN transaction_money ELSE 0 END) AS deposit_amount,
               SUM(CASE transaction_type WHEN 'withdrawals' THEN -transaction_money ELSE 0 END) AS withdraw_amount, --取款金额是负值
               SUM(CASE transaction_type WHEN 'backwater' THEN transaction_money ELSE 0 END) AS rakeback_amount,
               SUM(CASE transaction_type WHEN 'favorable' THEN transaction_money WHEN 'recommend' THEN transaction_money ELSE 0 END) AS favorable_amount,
               0 AS other_amount
          FROM pt
         GROUP BY player_id, player_name, agent_id, agent_name, topagent_id, topagent_name
      )
      INSERT INTO rebate_player_fee ( rebate_bill_id, topagent_id, topagent_name, agent_id, agent_name, player_id, player_name,
          deposit_amount, withdraw_amount, rakeback_amount, favorable_amount, other_amount
      ) SELECT p_bill_id, topagent_id, topagent_name, agent_id, agent_name, player_id, player_name,
          deposit_amount, withdraw_amount, rakeback_amount, favorable_amount, other_amount
      FROM ptu;


  ELSEIF p_settle_flag = 'N' THEN

    --v1.08  2018/06/06  Laser
    /*
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
               sys_user ut ON ua.owner_id = ut."id" AND ut.user_type = '22' --v1.01  2018/01/01  Laser
      )
      */
    WITH
      pt AS (
        SELECT player_id, user_name player_name, agent_id, agent_username agent_name, topagent_id, topagent_username topagent_name, transaction_type, SUM(transaction_money) transaction_money
          FROM player_transaction
         WHERE status = 'success'
           AND completion_time >= p_start_time
           AND completion_time < p_end_time
           AND transaction_type IN ( 'deposit', 'withdrawals', 'backwater', 'favorable', 'recommend')
         GROUP BY player_id, user_name, agent_id, agent_username, topagent_id, topagent_username, transaction_type
      ),

      ptu AS (
        SELECT player_id, player_name, agent_id, agent_name, topagent_id, topagent_name,
               SUM(CASE transaction_type WHEN 'deposit' THEN transaction_money ELSE 0 END) AS deposit_amount,
               SUM(CASE transaction_type WHEN 'withdrawals' THEN -transaction_money ELSE 0 END) AS withdraw_amount, --取款金额是负值
               SUM(CASE transaction_type WHEN 'backwater' THEN transaction_money ELSE 0 END) AS rakeback_amount,
               SUM(CASE transaction_type WHEN 'favorable' THEN transaction_money WHEN 'recommend' THEN transaction_money ELSE 0 END) AS favorable_amount,
               0 AS other_amount
          FROM pt
         GROUP BY player_id, player_name, agent_id, agent_name, topagent_id, topagent_name
      )
      INSERT INTO rebate_player_fee_nosettled ( rebate_bill_id, topagent_id, topagent_name, agent_id, agent_name, player_id, player_name,
          deposit_amount, withdraw_amount, rakeback_amount, favorable_amount, other_amount
      ) SELECT p_bill_id, topagent_id, topagent_name, agent_id, agent_name, player_id, player_name,
          deposit_amount, withdraw_amount, rakeback_amount, favorable_amount, other_amount
      FROM ptu;

  END IF;
END;

$BODY$
  LANGUAGE 'plpgsql' VOLATILE COST 100
;


COMMENT ON FUNCTION "gb_rebate_player_fee"(p_bill_id int4, p_start_time timestamp, p_end_time timestamp, p_settle_flag text) IS 'Laser-返佣结算账单.玩家费用';