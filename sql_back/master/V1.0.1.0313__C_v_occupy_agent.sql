-- auto gen by fly 2016-01-06 15:47:53

DROP VIEW IF EXISTS v_occupy_agent;
CREATE OR REPLACE VIEW v_occupy_agent AS
SELECT
	oa.agent_id id,
	oa.agent_name,
	ua.owner_id	top_agent_id,
	EXTRACT(year from ob.start_time)::VARCHAR occupy_year,
	EXTRACT(month from ob.start_time)::VARCHAR occupy_month,
	SUM(oa.effective_transaction) effective_transaction,
	SUM(oa.profit_loss)	profit_loss,
	SUM(oa.rakeback) 	rakeback,
	SUM(oa.preferential_value)	preferential_value,
	SUM(oa.refund_fee)	refund_fee,
	SUM(oa.rebate)	rebate,
	SUM(oa.apportion)	apportion,
	SUM(oa.occupy_total)	occupy_total
FROM occupy_bill ob
LEFT JOIN occupy_agent oa ON ob."id" = oa.occupy_bill_id
LEFT JOIN sys_user ua ON oa.agent_id = ua."id"
WHERE ua.user_type = '23'
GROUP BY oa.agent_id, oa.agent_name, ua.owner_id, occupy_year, occupy_month;

ALTER TABLE v_occupy_agent OWNER TO postgres;
COMMENT ON VIEW v_occupy_agent IS '总代占成统计详细视图';


