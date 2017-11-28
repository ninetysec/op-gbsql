-- auto gen by cherry 2017-03-06 10:58:05
UPDATE sys_resource SET url='home/Index.html' WHERE id=31;

INSERT INTO sys_param ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id") SELECT 'setting', 'api_setting', 'auto_pay', 'false', 'false', '1', 'api额度免转开关', NULL, 't', NULL

where NOT EXISTS (select id from sys_param where module='setting' and param_type='api_setting' and param_code='auto_pay');