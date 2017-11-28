-- auto gen by bruce 2017-04-10 14:00:09
DROP VIEW IF EXISTS v_agent_fund_record;
CREATE OR REPLACE VIEW "v_agent_fund_record" AS
 SELECT
   o.id,
   o.transaction_no,
   o.agent_id,
   o.create_time,
   b.transaction_money,
   b.balance,
   CASE o.settlement_state
      WHEN '2'::text THEN '4'::text
      WHEN '3'::text THEN '2'::text
      ELSE 'ONO'::text
   END AS status,
    1 AS type,
    b_1.start_time,
    b_1.end_time AS deadline
   FROM agent_rebate_order o
             LEFT JOIN agent_rebate b_1 ON o.rebate_bill_id = b_1.id
     LEFT JOIN agent_water_bill b ON o.id = b.order_id
  WHERE ((o.settlement_state)::text = '3'::text)
UNION
 SELECT a.id,
    a.transaction_no,
    a.agent_id,
    a.create_time,
    b.transaction_money,
    b.balance,
    a.transaction_status AS status,
    2 AS type,
    now() AS start_time,
    now() AS deadline
   FROM (agent_withdraw_order a
     LEFT JOIN agent_water_bill b ON (((a.id = b.order_id) AND (a.agent_id = b.agent_id))))