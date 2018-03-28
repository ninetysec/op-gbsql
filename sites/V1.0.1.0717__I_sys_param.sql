-- auto gen by linsen 2018-03-28 11:56:08
--新增分机号码设置 by back

INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT  'setting', 'system_setting', 'extension_number', '', '', NULL, '玩家联系站长-分机号码设置', NULL, 't', NULL, 'f', '1'
WHERE  'extension_number' not in (SELECT param_code FROM sys_param WHERE module ='setting' AND param_type='system_setting' AND param_code='extension_number' );



