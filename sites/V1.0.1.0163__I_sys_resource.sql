-- auto gen by bruce 2016-05-31 15:32:05
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
  SELECT 350104, '权限修改', 'sysResource/resetPermissions.html', '子账户-权限修改', '3501', NULL, NULL, 'mcenterAgent', 'system:subaccount_permis', '2', NULL, 't', 'f', 't'
  WHERE NOT EXISTS (select id from sys_resource t where t.id = 350104);
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
  SELECT 70304, '权限修改', 'sysResource/resetPermissions.html', '子账户-权限修改', '703', NULL, NULL, 'mcenter', 'system:subaccount_permis', '2', NULL, 't', 'f', 't'
  WHERE NOT EXISTS (select id from sys_resource t where t.id = 70304);
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
  SELECT 250104, '权限修改', 'sysResource/resetPermissions.html', '子账户-权限修改', '2501', NULL, NULL, 'mcenterTopAgent', 'system:subaccount_permis', '2', NULL, 't', 'f', 't'
  WHERE NOT EXISTS (select id from sys_resource t where t.id = 250104);

UPDATE sys_resource SET "name" = '权限查看' WHERE "id" = '70302';
UPDATE sys_resource SET "name" = '权限查看' WHERE "id" = '250102';
UPDATE sys_resource SET "name" = '权限查看' WHERE "id" = '350102';