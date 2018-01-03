-- auto gen by cherry 2017-11-09 09:31:38
INSERT INTO "sys_param"
("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'system_settings', 'name_verification', 'false', NULL, NULL, '玩家真实姓名验证', NULL, 't', NULL
WHERE NOT EXISTS(SELECT ID FROM sys_param WHERE param_code='name_verification');