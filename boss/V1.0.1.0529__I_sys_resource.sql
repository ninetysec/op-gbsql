-- auto gen by linsen 2018-03-12 23:08:35
-- 风控审核菜单 edit by back

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
 SELECT  '216', '风控审核', 'riskManagementCheck/list.html', '风控审核', '2', '', '16', 'boss', 'serve:examine', '1', '', 'f', 't', 't'
WHERE NOT EXISTS ( SELECT id FROM sys_resource WHERE id=216);

-- 风控列表菜单
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT   '217', '风控列表', 'riskManagement/list.html', '风控列表', '2', '', '17', 'boss', 'serve:record', '1', '', 'f', 't', 't'
WHERE NOT EXISTS ( SELECT id  FROM sys_resource WHERE id =217);

-- 风控审核的权限
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '21601', '审核', '', '风控审核-审核', '216', '', NULL, 'boss', 'serve:risk_managementcheck_risk', '2', '', 'f', 't', 't'
WHERE NOT  EXISTS (SELECT id FROM sys_resource WHERE id=21601);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT  '21603', '删除', 'riskManagementCheck/delRisk.html', '风控审核-删除', '216', '', NULL, 'boss', 'serve:risk_managementcheck_del', '2', '', 'f', 't', 't'
WHERE NOT EXISTS (SELECT id FROM sys_resource WHERE  id=21603);


-- 风控列表的权限
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT'21701', '新增', 'riskManagement/create.html', '风控数据-新增', '217', '', NULL, 'boss', 'serve:risk_management_add', '2', '', 'f', 't', 't'
WHERE NOT EXISTS (SELECT id FROM sys_resource WHERE id =21701);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '21702', '删除', 'riskManagement/delete.html', '风控数据-删除', '217', '', NULL, 'boss', 'serve:risk_management_delete', '2', '', 'f', 't', 't'
WHERE NOT EXISTS(SELECT id FROM sys_resource WHERE id=21702);

INSERT INTO "gb-boss"."sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '21703', '编辑', 'riskManagement/edit.html', '风控数据-编辑', '217', NULL, NULL, 'boss', 'serve:risk_management_edit', '2', '', 'f', 't', 't'
WHERE NOT EXISTS (SELECT id FROM sys_resource WHERE id=21703);

