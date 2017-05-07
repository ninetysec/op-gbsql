-- auto gen by admin 2017-05-06 15:00:01
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '411', '资金检测', 'report/vPlayerFundsRecord/fundsLog.html', '总控-报表-资金检测', '4', '', '11', 'boss', 'report:zjjc', '1', NULL, 'f', 't', 't'
where not EXISTS(SELECT id FROM sys_resource WHERE id='411');