-- auto gen by linsen 2018-05-02 17:47:02
--活动大厅开关 by steffan
INSERT INTO sys_param (  "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
select 'setting', 'parameter_setting', 'activity_hall_switch', 'false', 'false', NULL, '活动大厅开关', NULL, 't', NULL, 'f', '2'
where not exists (select id from sys_param where module='setting' and  param_type='parameter_setting' and param_code='activity_hall_switch' );
