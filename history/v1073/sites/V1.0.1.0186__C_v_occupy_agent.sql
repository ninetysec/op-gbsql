-- auto gen by admin 2016-06-30 15:45:22
INSERT INTO sys_param (module, param_type, param_code, param_value, default_value, order_num, remark, parent_code, active, site_id)

SELECT 'setting', 'rebateSetting', 'settlement.period.times.new', NULL, NULL, '2', '返佣设置-新结算周期-每月次数', NULL, 'f', NULL

 WHERE NOT EXISTS(SELECT param_value FROM sys_param WHERE param_type='rebateSetting' AND param_code='settlement.period.times.new');

INSERT INTO sys_param (module, param_type, param_code, param_value, default_value, order_num, remark, parent_code, active, site_id)

SELECT 'setting', 'rebateSetting', 'settlement.period.effective.time', NULL, NULL, '3', '返佣设置-新结算周期-生效时间', NULL, 'f', NULL

 WHERE NOT EXISTS(SELECT param_value FROM sys_param WHERE param_type='rebateSetting' AND param_code='settlement.period.effective.time');

INSERT INTO sys_param (module, param_type, param_code, param_value, default_value, order_num, remark, parent_code, active, site_id)

SELECT 'setting', 'rakebackSetting', 'settlement.period.times.new', NULL, NULL, '2', '返水设置-新结算周期-每月次数', NULL, 'f', NULL

 WHERE NOT EXISTS(SELECT param_value FROM sys_param WHERE param_type='rakebackSetting' AND param_code='settlement.period.times.new');

INSERT INTO sys_param (module, param_type, param_code, param_value, default_value, order_num, remark, parent_code, active, site_id)

SELECT 'setting', 'rakebackSetting', 'settlement.period.effective.time', NULL, NULL, '3', '返水设置-新结算周期-生效时间', NULL, 'f', NULL

 WHERE NOT EXISTS(SELECT param_value FROM sys_param WHERE param_type='rakebackSetting' AND param_code='settlement.period.effective.time');

DROP VIEW IF EXISTS v_occupy_agent;

CREATE OR REPLACE VIEW v_occupy_agent AS

 SELECT oa.agent_id id,

		oa.agent_name,

		ua.owner_id	top_agent_id,

		ob.start_time,

		ob.end_time,

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

  GROUP BY oa.agent_id, oa.agent_name, ua.owner_id, ob.start_time, ob.end_time;



COMMENT ON VIEW v_occupy_agent IS 'Fei - 总代占成统计详细视图';