-- auto gen by linsen 2018-03-12 23:08:35
--boss库菜单和权限 add by steffan
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '216', '风控审核', 'riskManagementCheck/list.html', '风控审核', '2', '', '16', 'boss', 'serve:risk_management_check', '1', '', 'f', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=216);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '21601', '查看列表', 'riskManagementCheck/list.html', '风控审核-查看列表', '216', '', NULL, 'boss', 'serve:risk_management_check_list', '2', '', 'f', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=21601);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '21602', '通过', 'riskManagementCheck/checkRisk.html', '风控审核-审核', '216', '', NULL, 'boss', 'serve:risk_management_check_risk', '2', '', 'f', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=21602);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '21603', '通过', 'riskManagementCheck/delRisk.html', '风控审核-删除', '216', '', NULL, 'boss', 'serve:risk_management_check_del', '2', '', 'f', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=21603);



INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '217', '风控列表', 'riskManagement/list.html', '风控列表', '2', '', '17', 'boss', 'serve:risk_management', '1', '', 'f', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=217);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '21701', '查看列表', 'riskManagement/list.html', '风控列表-查看列表', '217', '', NULL, 'boss', 'serve:risk_management_list', '2', '', 'f', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=21701);


INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '21702', '查看列表', 'riskManagement/delete.html', '风控列表-删除', '217', '', NULL, 'boss', 'serve:risk_management_delete', '2', '', 'f', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=21702);
