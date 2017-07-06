-- auto gen by cherry 2017-06-30 16:18:40
INSERT INTO"sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'withdraw_type', 'is_cash', 'true', 'true', NULL, '是否用现金打款', NULL, 't', NULL
WHERE not EXISTS(SELECT id FROM sys_param WHERE module='setting' and param_type='withdraw_type' and param_code='is_cash');


INSERT INTO"sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'withdraw_type', 'is_bitcoin', 'false', 'false', NULL, '是否用比特币打款', NULL, 't', NULL
WHERE not EXISTS(SELECT id FROM sys_param WHERE module='setting' and param_type='withdraw_type' and param_code='is_bitcoin');