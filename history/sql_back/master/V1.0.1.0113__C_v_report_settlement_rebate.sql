-- auto gen by fly 2015-10-14 10:21:28
DROP VIEW IF EXISTS v_report_settlement_rebate;
CREATE OR REPLACE VIEW v_report_settlement_rebate AS
	SELECT
		sra.id id,
		sr.id rebate_id,
		sra.effective_player,
		sra.effective_transaction,
		sra.profit_loss,
		sra.deposit_amount,
		sra.withdrawal_amount,
		sra.backwater,
		sra.preferential_value,
		sra.deduct_expenses,
		sra.rebate_total,
		sra.rebate_actual,
		sr.settlement_name,
		sr.start_time,
		sr.end_time,
		sra.agent_name,
		sr.lssuing_state
	FROM settlement_rebate sr
	LEFT JOIN settlement_rebate_agent sra
		ON sr.id = sra.settlement_rabate_id
	WHERE sra.id is NOT NULL;

ALTER TABLE v_report_settlement_rebate OWNER TO postgres;
COMMENT ON VIEW v_report_settlement_rebate IS '返佣统计视图';
