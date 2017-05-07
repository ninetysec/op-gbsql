-- auto gen by cherry 2016-03-02 10:21:28
DELETE FROM sys_param WHERE module='setting' AND param_type='system_settings';


INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id") VALUES ( 'setting', 'system_settings', 'sms', 'true', 'true', '1', '启用短信功能', NULL, 't', NULL);
INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id") VALUES ( 'setting', 'system_settings', 'mail', 'true', 'true', '2', '启用邮件功能', NULL, 't', NULL);
INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id") VALUES ( 'setting', 'system_settings', 'customer', 'true', 'true', '3', '启用客服站内信', NULL, 't', NULL);
INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id") VALUES ( 'setting', 'system_settings', 'disable', 'true', 'true', '4', '启用禁用右键', NULL, 't', NULL);
INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id") VALUES ( 'setting', 'system_settings', 'player', 'false', 'true', '5', '启用玩家注册', NULL, 't', NULL);
INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id") VALUES ( 'setting', 'system_settings', 'proxy', 'true', 'true', '6', '启用代理注册', NULL, 't', NULL);
INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id") VALUES ( 'setting', 'system_settings', 'deposit', 'true', 'true', '7', '启用存款稽核', NULL, 't', NULL);
INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id") VALUES ( 'setting', 'system_settings', 'discount', 'true', 'true', '8', '启用优惠稽核', NULL, 't', NULL);


DELETE FROM sys_param WHERE module='setting' AND param_type='operate_manage' AND param_code='points';
DELETE FROM sys_param WHERE module='setting' AND param_type='operate_manage' AND param_code='mall';
DELETE FROM sys_param WHERE module='setting' AND param_type='operate_manage' AND param_code='level';
