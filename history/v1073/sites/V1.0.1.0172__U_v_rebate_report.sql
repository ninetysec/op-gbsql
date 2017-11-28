-- auto gen by fei 2016-06-16 10:50:37
DROP VIEW IF EXISTS v_rebate_report;
CREATE OR REPLACE VIEW v_rebate_report AS
 SELECT rb.id,
        rg.agent_name,
        su.username as topagent_name,
        rg.effective_player,
        rg.effective_transaction,
        rg.profit_loss,
        rg.deposit_amount,
        rg.withdrawal_amount,
        rg.rakeback,
        (rg.preferential_value + rg.recommend) as preferential_value,
        rg.apportion,
        rg.refund_fee,
        rg.rebate_total,
        rg.rebate_actual,
        rg.settlement_state,
		rg.history_apportion,
        rb.start_time,
        rb.end_time,
        rb.period
   FROM rebate_bill rb
     LEFT JOIN rebate_agent rg ON rb.id = rg.rebate_bill_id
     LEFT JOIN user_agent ua ON rg.agent_id = ua.id
     LEFT JOIN sys_user su ON ua.parent_id = su.id
  WHERE rg.id IS NOT NULL AND rb.end_time >= (now() - '90 days'::interval);

ALTER TABLE v_rebate_report OWNER TO "gb-site-2";

COMMENT ON VIEW v_rebate_report IS '返佣统计详细视图 - add by Fei edit by younger';