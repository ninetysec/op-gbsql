-- auto gen by george 2018-01-23 14:24:53

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '30622', '修改站点名称', '', '修改站点名称', '306', NULL, NULL, 'boss', 'site:update_siteName', '2', NULL, 'f', 't', 't'
WHERE '30622' NOT IN (SELECT id FROM sys_resource where id='30622');