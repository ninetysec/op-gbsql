-- auto gen by cherry 2016-02-05 11:38:17
INSERT INTO sys_param ("module","param_type", "param_code", "param_value", 	"default_value", "order_num", "remark","parent_code","active","site_id")
SELECT 'setting', 'visit', 	'visit.management.center.prompt', 'true', 	'true', NULL, '是否开启允许访问管理中心的IP,是否需要显示提示语', NULL, 	't',0
WHERE 'visit.management.center.prompt' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='visit');

