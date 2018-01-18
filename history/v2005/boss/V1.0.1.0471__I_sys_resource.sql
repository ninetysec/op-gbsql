-- auto gen by george 2017-12-19 09:44:41
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '20104', '查看列表', 'vSysDomainCheck/list.html', '域名审核-查看列表', '201', '', NULL, 'boss', 'serve:domain_list', '2', '', 'f', 't', 't'
WHERE NOT EXISTS (SELECT id from sys_resource where id = 20104)

