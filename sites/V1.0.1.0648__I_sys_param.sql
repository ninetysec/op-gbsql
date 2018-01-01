-- auto gen by cherry 2018-01-01 14:26:53
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active"
select 'fund', 'recharge', 'support_intelligent_cash_flow', 'false', 'false', NULL, '是否支持智能金流顺序', NULL, 't', NULL, 't'
where not EXISTS (SELECT id FROM sys_param where "module"='fund' AND "param_type"='recharge' and param_code='support_intelligent_cash_flow');
