-- auto gen by steffan 2018-07-08 17:14:37
-- 站点运维状态外围接口地址
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
select 'op', 'maintain_op_page_cache_addr', 'maintain_op_page_cache_addr', 'http://sync1.gbboss.com','http://sync1.gbboss.com', NULL, '站点运维状态外围接口地址', NULL, 't', '0'
WHERE not EXISTS (SELECT id FROM sys_param WHERE module='op' AND param_type='op_purge_out_maintain_addr' and param_code='op_purge_out_maintain_addr');
