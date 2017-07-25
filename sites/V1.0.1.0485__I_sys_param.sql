-- auto gen by tony 2017-07-25 10:52:57
INSERT INTO sys_param ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 	'setting', 	'system_settings', 	'is_lottery_site', 'false', 'false', 	NULL, 	'启用是否纯彩票站点', NULL, 	't', 	NULL
WHERE  'is_lottery_site' not in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='system_settings' );