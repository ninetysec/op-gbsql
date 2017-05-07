-- auto gen by brave 2017-01-17 12:54:54
INSERT INTO "sys_resource"
("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '410', '投注检测', 'report/gameTransaction/transacCheckList.html', '总控-报表-投注检测', '4', '', '10', 'boss', 'report:tzjc', '1', NULL, 'f', 't', 't'
WHERE not EXISTS(SELECT id FROM sys_resource WHERE id = 410);