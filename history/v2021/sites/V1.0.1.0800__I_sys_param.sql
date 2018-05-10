-- auto gen by linsen 2018-05-07 11:50:15
-- 用户自定义提示音 by linsen
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT 'setting', 'warming_tone_project', 'deposit_defined', '', '', '1', '公司存款-自定义提示音', NULL, 'f', NULL, 'f', NULL
WHERE NOT EXISTS(SELECT id FROM sys_param WHERE module='setting' AND param_type='warming_tone_project' AND param_code='deposit_defined');

INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT 'setting', 'warming_tone_project', 'onlinePay_defined', '', '', '2', '线上支付-自定义提示音', NULL, 'f', NULL, 'f',NULL
WHERE NOT EXISTS(SELECT id FROM sys_param WHERE module='setting' AND param_type='warming_tone_project' AND param_code='onlinePay_defined');


INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT 'setting', 'warming_tone_project', 'draw_defined', '', '', '3', '取款-自定义提示音', NULL, 'f', NULL, 'f', NULL
WHERE NOT EXISTS(SELECT id FROM sys_param WHERE module='setting' AND param_type='warming_tone_project' AND param_code='draw_defined');

INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT 'setting', 'warming_tone_project', 'audit_defined', '', '', '4', '审批-自定义提示音', NULL, 'f', NULL, 'f', NULL
WHERE NOT EXISTS(SELECT id FROM sys_param WHERE module='setting' AND param_type='warming_tone_project' AND param_code='audit_defined');


INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT 'setting', 'warming_tone_project', 'warm_defined', '', '', '5', '警告-自定义提示音', NULL, 'f', NULL, 'f', NULL
WHERE NOT EXISTS(SELECT id FROM sys_param WHERE module='setting' AND param_type='warming_tone_project' AND param_code='warm_defined');


INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT 'setting', 'warming_tone_project', 'notice_defined', '', '', '6', '通知-自定义提示音', NULL, 'f', NULL, 'f', NULL
WHERE NOT EXISTS(SELECT id FROM sys_param WHERE module='setting' AND param_type='warming_tone_project' AND param_code='notice_defined');

