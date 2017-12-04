-- auto gen by cherry 2017-08-05 11:48:34
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'credit', 'takeTurns', 'true', 'true', NULL, '是否开启轮流入款', NULL, 't', '0'
where not EXISTS (SELECT id FROM sys_param where module='setting' and param_type='credit' and param_code='takeTurns');

INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'credit', 'scale', '10', '10', NULL, '购买额度比例', NULL, 't', '0'
WHERE not EXISTS (SELECT id FROM sys_param WHERE module='setting' and param_type='credit' and param_code='scale');

INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'credit', 'profit_left_time', '24', '24', NULL, '买分默认剩余时间 以小时为单位', NULL, 't', '0'
WHERE not EXISTS (SELECT id FROM sys_param WHERE module='setting' and param_type='credit' and param_code='profit_left_time');
