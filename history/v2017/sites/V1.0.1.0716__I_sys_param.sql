-- auto gen by linsen 2018-03-28 10:21:29
--添加短信开关 by carl
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
select 'setting', 'sms_setting', 'sms_switch', NULL, 'false', '1', '短信开关', NULL, 'f', '1', NULL, '1'
where 'sms_switch' not in (select param_code from sys_param where module='setting' AND param_type='sms_setting' AND param_code = 'sms_switch');
--添加找回密码短信开关
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
select 'setting', 'sms_setting', 'recover_password', NULL, 'false', '1', '找回密码短信开关', NULL, 'f', '1', NULL, '1'
where 'recover_password' not in (select param_code from sys_param where module='setting' AND param_type='sms_setting' AND param_code = 'recover_password');
