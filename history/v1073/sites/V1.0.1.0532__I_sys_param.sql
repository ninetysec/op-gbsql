-- auto gen by cherry 2017-09-23 11:21:39
INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'system_settings', 'mobile_traffic_statistics', '', NULL, NULL, '手机端流量统计代码', NULL, 't', NULL
WHERE NOT EXISTS(SELECT ID FROM sys_param WHERE param_code='mobile_traffic_statistics');
