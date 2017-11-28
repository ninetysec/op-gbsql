-- auto gen by cherry 2017-09-30 09:29:33
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
select 'setting', 'credit', 'large_transaction_amount', '100000', '100000', NULL, '大额交易监控', NULL, 't', '0'
WHERE not EXISTS (SELECT id FROM sys_param WHERE module='setting' AND param_type='credit' and param_code='large_transaction_amount');

INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
select 'setting', 'credit', 'transfer_limit_warn', '100', '100', NULL, '转账上限超出百分比例提醒', NULL, 't', '0'
WHERE not EXISTS (SELECT id FROM sys_param WHERE module='setting' AND param_type='credit' and param_code='transfer_limit_warn');


INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
select 'setting', 'credit', 'transfer_limit_stop', '120', '120', NULL, '转账上限超出百分比例立即停止转账', NULL, 't', '0'
WHERE not EXISTS (SELECT id FROM sys_param WHERE module='setting' AND param_type='credit' and param_code='transfer_limit_stop');
