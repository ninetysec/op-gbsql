-- auto gen by cherry 2017-08-12 15:59:44
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'system_settings', 'app_domain', '', '', '10', '设置APP下载域名', NULL, 't', NULL
where not exists (select id from sys_param where module='setting'
and param_type='system_settings' and param_code='app_domain');