-- auto gen by george 2018-01-22 11:14:08
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '30621', '站点维护', 'sysSite/siteMaintain.html', '站点维护', '306', NULL, NULL, 'boss', 'site:sitemanage_mintain', '2', NULL, 't', 't', 't'
WHERE '30621' NOT IN (SELECT id FROM sys_resource where id='30621');