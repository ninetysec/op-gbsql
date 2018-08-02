-- auto gen by linsen 2018-07-09 10:26:22
-- API服务分离 by mical
INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
  select  'setting', 'system_settings', 'api_separat', 'false', 'false', NULL, 'API服务分离', '', 't', NULL, 't', '0'
  where not exists (select id from sys_param where module='setting' AND param_type='system_settings' AND param_code='api_separat');