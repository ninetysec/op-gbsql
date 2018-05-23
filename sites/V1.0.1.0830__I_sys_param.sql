-- auto gen by steffan 2018-05-22 20:06:57  add by mical
INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
select  'setting', 'system_settings', 'cdn_url', '', '', NULL, 'cdn地址', '', 't', NULL, 'f', '0'
where not exists (select id from sys_param where module='setting' AND param_type='system_settings' AND param_code='cdn_url');


INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
select 'setting', 'system_settings', 'cdn_switch', 'true', '', NULL, 'cnd开关', '', 't', NULL, 't', '0'
where not exists (select id from sys_param where module='setting' AND param_type='system_settings' AND param_code='cdn_switch');