-- auto gen by linsen 2018-03-04 19:03:57
-- author : mical
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
select 'setting', 'system_settings', 'cdn_switch', 'true', '', NULL, 'cnd开关', '', 't', NULL, 'true', '0'
where not EXISTS(SELECT ID FROM sys_param WHERE module ='setting' AND  param_type = 'system_settings' AND param_code='cdn_switch');