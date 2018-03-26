-- auto gen by linsen 2018-03-26 11:25:50
--站长中心-系统设置-前端展示-新增个人信息开关 by back

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT 'setting', 'contact_information', 'personal_information', '00000000', '00000000', NULL, '个人信息设置', NULL, 't', NULL, 'f', '1'
WHERE 'personal_information' not in (SELECT  param_code FROM sys_param WHERE module ='setting'AND param_type='contact_information' AND param_code='personal_information');


--站长中心-系统设置-参数设置-电销开关和电话加密开关

INSERT INTO  "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT 'setting', 'parameter_setting', 'is_telemarketing', 'false', 'false', NULL, '电销开关', NULL, 't', NULL, 'f', '1'
WHERE 'is_telemarketing' not in (SELECT param_code FROM sys_param WHERE module='setting' AND param_type='parameter_setting' AND param_code='is_telemarketing');


INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT 'setting', 'parameter_setting', 'is_encryption', 'false', 'false', NULL, '电话加密开关', NULL, 't', NULL, 'f', '1'
WHERE 'is_encryption' not in (SELECT param_code FROM sys_param WHERE module ='setting'  AND param_type='parameter_setting' AND param_code='is_encryption');
