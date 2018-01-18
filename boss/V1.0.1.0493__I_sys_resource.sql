-- auto gen by george 2018-01-18 16:15:27
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '21101', '站点API大分类排序', '', '站点API大分类排序', '211', NULL, NULL, 'boss', 'siteApi:typeOrder', '1', NULL, 'f', 't', 't'
WHERE '21101' NOT IN (SELECT id FROM sys_resource where id='21101');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '21102', '站点API排序', '', '站点API排序', '211', NULL, NULL, 'boss', 'siteApi:order', '1', NULL, 'f', 't', 't'
WHERE '21102' NOT IN (SELECT id FROM sys_resource where id='21102');