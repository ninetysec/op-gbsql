-- auto gen by brave 2017-01-16 03:50:19
INSERT INTO sys_param ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
select 'setting', 'export', 'export_players', 'true', 'true', '1', '是否开启导出玩家功能', NULL, 't', NULL
where NOT EXISTS (select id from sys_param where module='setting' and param_type='export' and param_code='export_players');