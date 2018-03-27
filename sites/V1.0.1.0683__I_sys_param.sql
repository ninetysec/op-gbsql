-- auto gen by linsen 2018-02-26 09:40:49
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT 'setting', 'credit', 'max.profit.limit.percent', '150', '150', '10', '额度上线比例', NULL, 't', NULL, 'f', NULL
WHERE 'max.profit.limit.percent' not in (SELECT param_code from sys_param where module='setting' AND param_type='credit');