-- auto gen by fly 2015-10-15 17:37:50
DROP VIEW IF EXISTS v_report_settlement_rebate_detail;
CREATE OR REPLACE VIEW v_report_settlement_rebate_detail AS
SELECT
	sra."id",
	sr."id" rebate_id,
	sra.agent_name,
	su.username,
	sra.effective_transaction,
	sra.profit_loss,
	sra.deposit_amount,
	sra.withdrawal_amount,
	sra.backwater,
	sra.preferential_value,
	sra.deduct_expenses,
	sra.rebate_total,
	sr.lssuing_state,
	sr.start_time,
	sr.end_time,
	sr.settlement_name
FROM
	settlement_rebate sr
LEFT JOIN settlement_rebate_agent sra
	ON sr."id" = sra.settlement_rabate_id
LEFT JOIN user_agent ua
	ON sra.agent_id = ua."id"
LEFT JOIN sys_user su
	ON ua.parent_id = su."id"
WHERE sra."id" IS NOT NULL
	AND sr.end_time >= now()-interval '90 day';

ALTER TABLE v_report_settlement_rebate_detail OWNER TO postgres;
COMMENT ON VIEW v_report_settlement_rebate_detail IS '返佣统计详细视图';
