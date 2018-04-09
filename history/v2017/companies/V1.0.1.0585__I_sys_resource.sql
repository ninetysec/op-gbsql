-- auto gen by tony 2018-03-26 10:25:19
INSERT INTO
"sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT  '3060815', '菜单管理', '/site/detail/viewMenuAdministration.html', '菜单管理', '30608', NULL, '15', 'boss', 'platform:view_menuAdministration', '2', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT id FROM sys_resource WHERE id=3060815);