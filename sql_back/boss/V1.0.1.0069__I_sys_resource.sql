-- auto gen by cherry 2016-01-25 18:02:18
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '3013', '重置登录密码', 'platform/operatorsManage/resetPwd.html', '重置登录密码', '301', NULL, '3', 'boss', 'test:view', '2', NULL, 't', 'f', 't'
WHERE '3013' NOT in(SELECT id FROM sys_resource);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '3014', '重置安全密码', 'platform/operatorsManage/resetPermissionPwd.html', '重置安全密码', '301', '', '4', 'boss', 'test:view', '2', '', 't', 'f', 't'
WHERE '3014' NOT in(SELECT id FROM sys_resource);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '3015', '查看联系方式', 'platform/operatorsManage/viewContact.html', '查看联系方式', '301', NULL, '5', 'boss', 'test:view', '2', NULL, 't', 'f', 't'
where  '3015' NOT in(SELECT id FROM sys_resource);