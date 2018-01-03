-- auto gen by cherry 2017-11-10 11:55:32
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'system_settings', 'mobile_upgrade', 'false', 'false', '9', 'mobile-v3是否启用', NULL, 't', NULL
where not EXISTS (SELECT * FROM sys_param where module='setting' AND param_type='system_settings' AND param_code='mobile_upgrade')
