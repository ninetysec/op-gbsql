-- auto gen by george 2017-12-10 09:49:40
--代理返佣视图
DROP VIEW IF EXISTS v_agent_rebate_order;
CREATE OR REPLACE VIEW "v_agent_rebate_order" AS
SELECT o.id,    o.agent_id,
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
    a.rebate_bill_id,
    b.start_time,
    b.end_time,
    b.create_time AS bill_create_time,
    b.period
   FROM agent_rebate_order o
     LEFT JOIN rebate_agent a ON o.rebate_bill_id = a.id
     LEFT JOIN rebate_bill b ON a.rebate_bill_id = b.id
;
COMMENT ON VIEW "v_agent_rebate_order" IS '代理返佣订单视图';