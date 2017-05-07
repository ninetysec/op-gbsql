-- auto gen by cherry 2017-03-31 21:53:53
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'online_recharge', 'recharge_url', '', NULL, NULL, '线上支付-快速充值域名地址', '', 't', NULL
where not EXISTS (SELECT id FROM sys_param where module='setting' and param_type='online_recharge' and param_code='recharge_url');
