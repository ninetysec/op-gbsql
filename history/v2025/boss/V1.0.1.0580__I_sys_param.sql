-- auto gen by steffan 2018-07-01 21:02:55
-- 域名检测运维接口地址
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
select 'op', 'op_domain_check_addr', 'op_domain_check_addr', 'http://domaincheck.dayu-boss.com:20111','http://domaincheck.dayu-boss.com:20111', NULL, '域名检测地址OP提供的', NULL, 't', '0'
WHERE not EXISTS (SELECT id FROM sys_param WHERE module='op' AND param_type='op_domain_check_addr' and param_code='op_domain_check_addr');


