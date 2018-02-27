-- auto gen by linsen 2018-02-27 09:10:21
--出款账户
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
select 'fund', 'withdraw', 'withdraw_account', '{"withdrawChannel":"","merchantCode":"","platformId":"","key":""}', '', NULL, '出款账户', NULL, 't', NULL, 'f', NULL
where not EXISTS(SELECT ID FROM sys_param WHERE module ='fund' AND  param_type = 'withdraw' AND param_code='withdraw_account');