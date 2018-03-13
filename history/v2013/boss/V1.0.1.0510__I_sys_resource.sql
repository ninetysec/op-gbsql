-- auto gen by linsen 2018-01-31 14:48:40
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '524', 'APP域名错误', 'appDomainError/init.html', 'APP域名错误', '5', '', 24, 'boss', 'maintenance:appDomainError', '1', '', 't', 'f', 't'
WHERE 524 NOT IN(SELECT id FROM sys_resource WHERE id=524);