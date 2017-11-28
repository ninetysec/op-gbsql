-- auto gen by cherry 2017-10-26 14:53:01
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'fund', 'disable_transfer', 'false', 'false', NULL, '是否禁止转账 true-不能转账', NULL, 't', NULL
where not EXISTS (SELECT id FROM sys_param WHERE module='setting' AND param_type='fund' AND param_code='disable_transfer');
