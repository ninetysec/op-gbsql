-- auto gen by linsen 2018-03-27 15:08:05
--站长中心-电销参数-新增玩家联系站长开关 by back
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id", "is_switch", "operate")
SELECT 'setting', 'system_setting', 'contact_stationmaster', 'false', 'false', NULL, '玩家联系站长', NULL, 't', NULL, 'f', '1'
WHERE 'contact_stationmaster' not in (SELECT param_code FROM sys_param WHERE module ='setting'and  param_type='system_setting' and param_code='contact_stationmaster');