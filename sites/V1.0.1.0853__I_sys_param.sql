-- auto gen by linsen 2018-06-06 14:39:14
-- APP启动页 by kobe
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT 'setting', 'system_setting', 'app_start_page', 'false', 'false', '10', 'APP启动页', NULL, 't', NULL, 'f', '0'
WHERE 'app_start_page' not in (SELECT param_code from sys_param where module = 'setting' and param_type = 'system_setting');
