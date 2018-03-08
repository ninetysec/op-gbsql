-- auto gen by linsen 2018-03-06 21:06:14
--新增访问限制权限 by back
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT  '30206', '新增访问限制', 'siteConfineIp/create.html', '平台管理-详细-访问限制', '302', NULL, '6', 'boss', 'platform:access_restriction', '2', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT id FROM sys_resource WHERE id=30206);

--新增编辑访问限制 by back
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT  '30207', '编辑访问限制', 'siteConfineIp/edit.html', '平台管理-详细-访问限制编辑', '302', NULL, '7', 'boss', 'platform:edit_restriction', '2', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT id FROM sys_resource WHERE id=30207);

