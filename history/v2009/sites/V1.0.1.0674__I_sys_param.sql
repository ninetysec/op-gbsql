-- auto gen by george 2018-01-22 19:47:52

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT  'setting', 'contact_information', 'phone_number', '', NULL, NULL, '联系方式电话', NULL, 't', NULL, 't', NULL
WHERE NOT EXISTS (SELECT module,param_code,param_type FROM sys_param WHERE module = 'setting'  AND param_code = 'phone_number' AND param_type='contact_information');

INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
 SELECT 'setting', 'contact_information', 'e-mail', '', NULL, NULL, '联系方式邮箱', NULL, 't', NULL, 't', NULL
WHERE NOT EXISTS (SELECT module,param_code,param_type FROM sys_param WHERE module = 'setting'  AND param_code = 'e-mail' AND param_type='contact_information');


INSERT INTO  "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT 'setting', 'contact_information', 'qq', '', NULL, NULL, '联系方式qq', NULL, 't', NULL, 't', NULL
WHERE NOT EXISTS (SELECT module,param_code,param_type FROM sys_param WHERE module = 'setting'  AND param_code = 'qq' AND param_type='contact_information');


INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT 'setting', 'contact_information', 'skype', '', NULL, NULL, '联系方式Skyep', NULL, 't', NULL, 't', NULL
WHERE NOT EXISTS (SELECT module,param_code,param_type FROM sys_param WHERE module = 'setting'  AND param_code = 'skype' AND param_type='contact_information');


INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT 'setting', 'contact_information', 'copyright_information', '', NULL, NULL, '联系方式版权信息', NULL, 't', NULL, 't', NULL
WHERE NOT EXISTS (SELECT module,param_code,param_type FROM sys_param WHERE module = 'setting'  AND param_code = 'copyright_information' AND param_type='contact_information');


INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT 'setting', 'download_settings', 'qr_code_switch', 'false', 'false', NULL, '二维码登录显示开关', NULL, 't', NULL, 't', NULL
WHERE NOT EXISTS (SELECT module,param_code,param_type FROM sys_param WHERE module = 'setting'  AND param_code = 'qr_code_switch' AND param_type='download_settings');
