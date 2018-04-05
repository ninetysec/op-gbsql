-- auto gen by linsen 2018-04-04 21:05:30
-- 转账上限停止转账功能开关 by linsen
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT 'setting', 'credit', 'enable_transfer_limit', 'true', 'true', NULL, '转账上限停止转账功能开关', NULL, 't', '0', NULL, 0
WHERE NOT EXISTS (SELECT id FROM sys_param WHERE module='setting' AND param_type='credit' AND param_code='enable_transfer_limit');