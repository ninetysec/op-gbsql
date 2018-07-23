-- auto gen by linsen 2018-06-11 19:41:08
-- 是否导出玩家联系方式开关  by martin
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
select 'setting', 'export', 'export_player_contact', 'false', 'false', NULL, '是否导出玩家联系信息', NULL, 't', NULL, 't', '0'
where not exists (select id from sys_param where module='setting' and param_type='export' and param_code = 'export_player_contact');