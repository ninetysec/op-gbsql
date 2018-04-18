-- auto gen by cherry 2018-04-13 17:35:32
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value",
"default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT
	'setting',
	'system_setting',
	'customer_is_inlay',
	'false',
	'false',
	'1',
	'APP设置客户是否内嵌参数',
	NULL,
	't',
	NULL,
	'f',
	'0'
where not EXISTS (SELECT id FROM sys_param where param_code='customer_is_inlay');