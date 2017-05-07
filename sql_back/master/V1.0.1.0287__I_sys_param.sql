-- auto gen by orange 2015-12-24 14:30:51
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
select  'fund', 'remind', 'reminder_multiple', '0', '0', NULL, '取款提醒倍数，当玩家本次取款金额达到上次存款金额设定的倍数，审核时需提醒', NULL, 't', NULL
where 'reminder_multiple' not in (select param_code from sys_param where module='fund' and param_type='remind' and param_code = 'reminder_multiple');


