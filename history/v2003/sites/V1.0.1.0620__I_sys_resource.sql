-- auto gen by george 2017-12-04 09:09:19
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '3306', '资金记录', 'report/vPlayerFundsRecord/fundsLog.html', '报表记录-资金记录', '33', '', '5', 'mcenterAgent', 'report:capitalRecord', '1', NULL, 't', 'f', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='3306');
