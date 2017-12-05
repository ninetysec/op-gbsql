-- auto gen by george 2017-12-05 09:09:40

--重建代理返佣订单视图 by younger 2017-12-05
DROP VIEW IF EXISTS v_agent_rebate_order;
CREATE OR REPLACE VIEW "v_agent_rebate_order" AS
 SELECT o.id,
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
    b.start_time,
    b.end_time,
    b.create_time AS bill_create_time,
    b.period
   FROM (agent_rebate_order o
     LEFT JOIN rebate_bill b ON (((o.rebate_bill_id = b.id) AND (o.rebate_bill_id = b.id))));

COMMENT ON VIEW "v_agent_rebate_order" IS '代理返佣订单视图';