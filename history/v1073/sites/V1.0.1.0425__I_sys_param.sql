-- auto gen by cherry 2017-04-06 09:38:43

INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'online_recharge', 'recharge_url_all_rank', '', NULL, NULL, '线上支付-快速充值是否包含全部层级', '', 't', NULL
where not EXISTS (SELECT id FROM sys_param where module='setting' and param_type='online_recharge' and param_code='recharge_url_all_rank');


INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'online_recharge', 'recharge_url_ranks', '', NULL, NULL, '线上支付-快速充值层级', '', 't', NULL
where not EXISTS (SELECT id FROM sys_param where module='setting' and param_type='online_recharge' and param_code='recharge_url_ranks');
