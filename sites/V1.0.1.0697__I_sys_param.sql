-- auto gen by linsen 2018-03-06 21:07:45

--易收付出款入款开启/关闭控制 by linsen
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
select 'fund', 'withdraw', 'easy_payment', 'false', '', NULL, '开启易收付出款', NULL, 't', NULL, 'f', NULL
where not EXISTS(SELECT ID FROM sys_param WHERE module ='fund' AND  param_type = 'withdraw' AND param_code='easy_payment');