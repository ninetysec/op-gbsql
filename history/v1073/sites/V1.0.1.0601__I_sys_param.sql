-- auto gen by cherry 2017-11-14 10:15:18
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'system_settings', 'background_color', 'default', 'default', NULL, '手机端背景颜色类型', NULL, 't', NULL
WHERE NOT EXISTS(SELECT ID FROM sys_param WHERE param_type='system_settings' AND param_code='background_color');
