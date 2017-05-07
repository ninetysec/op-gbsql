-- auto gen by bruce 2016-08-23 16:10:09
DROP VIEW IF EXISTS v_agent_fund_record;
CREATE OR REPLACE VIEW "v_agent_fund_record" AS
    SELECT a.id,
    a.transaction_no,
    a.agent_id,
    a.create_time,
    b.transaction_money,
    b.balance,
    CASE a.settlement_state
      WHEN 'pending_lssuing'::text THEN '1'::text
      WHEN 'lssuing'::text THEN '2'::text
      WHEN 'reject_lssuing'::text THEN '4'::text
      ELSE 'ONO'::text
    END AS status,
    1 AS type,
    a.period AS periods,
    a.start_time,
    a.end_time as deadline
FROM (( SELECT o.id,
          o.agent_id,
          o.transaction_no,
          o.settlement_state,
          o.currency,
          o.rebate_amount,
          o.actual_amount,
          o.create_time,
          o.reason_title,
          o.reason_content,
          o.remark,
          o.user_id,
          o.username,
          o.rebate_bill_id,
          b_1.start_time,
          b_1.end_time,
          b_1.create_time AS bill_create_time,
          b_1.period
        FROM (agent_rebate_order o
          LEFT JOIN rebate_bill b_1 ON ((o.rebate_bill_id = b_1.id)))) a
  LEFT JOIN agent_water_bill b ON ((a.id = b.order_id)))
WHERE ((a.settlement_state)::text = 'lssuing'::text)
UNION
SELECT
    a.id,
    a.transaction_no,
    a.agent_id,
    a.create_time,
    b.transaction_money,
    b.balance,
    a.transaction_status AS status,
    2 AS type,
    ''::character varying AS periods,
    now() AS start_time,
    now() AS deadline
FROM (agent_withdraw_order a
    LEFT JOIN agent_water_bill b ON (((a.id = b.order_id) AND (a.agent_id = b.agent_id))));

COMMENT ON VIEW "v_agent_fund_record" IS '账户资金';