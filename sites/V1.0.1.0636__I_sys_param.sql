-- auto gen by george 2017-12-18 21:07:48
INSERT INTO  sys_param  ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting','system_settings','popup_switch','true','false',NULL,'玩家中心弹窗开关', NULL, 't', NULL
WHERE 'popup_switch' not in  ( SELECT param_code FROM sys_param WHERE module ='setting' AND param_type='system_settings');