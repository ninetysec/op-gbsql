-- auto gen by admin 2016-05-25 19:15:47
DROP VIEW if EXISTS v_rebate_report;
CREATE OR REPLACE VIEW "v_rebate_report" AS

 SELECT rb.id,

    rg.agent_name,

    su.username AS topagent_name,

    rg.effective_player,

    rg.effective_transaction,

    rg.profit_loss,

    rg.deposit_amount,

    rg.withdrawal_amount,

    rg.rakeback,

    (rg.preferential_value + rg.recommend) AS preferential_value,

    rg.apportion,

    rg.refund_fee,

    rg.rebate_total,

    rg.rebate_actual,

    rg.settlement_state,

    rb.start_time,

    rb.end_time,

    rb.period

   FROM (((rebate_bill rb

     LEFT JOIN rebate_agent rg ON ((rb.id = rg.rebate_bill_id)))

     LEFT JOIN user_agent ua ON ((rg.agent_id = ua.id)))

     LEFT JOIN sys_user su ON ((ua.parent_id = su.id)))

  WHERE ((rg.id IS NOT NULL) AND (rb.end_time >= (now() - '90 days'::interval)));

COMMENT ON VIEW "v_rebate_report" IS '返佣统计详细视图 - add by Fei edit by younger';