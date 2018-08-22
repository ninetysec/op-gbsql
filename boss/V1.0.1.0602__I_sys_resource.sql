-- auto gen by linsen 2018-08-22 11:08:13
-- API备用域名 by linsen
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '921', 'API备用域名', 'apiDomain/list.html', 'API备用域名', '9', '', '21', 'boss', 'api:api_domain', '1', '', 'f', 't', 't'
WHERE NOT EXISTS (SELECT ID FROM sys_resource WHERE ID =921);