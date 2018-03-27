-- auto gen by linsen 2018-01-28 16:37:55
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '215', '域名审核新版', 'vDomainCheck/list.html', '域名审核新版', '2', '', '15', 'boss', 'serve:domain_check', '1', '', 'f', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=215);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '21501', '查看列表', 'vDomainCheck/list.html', '域名审核新版-查看列表', '215', '', NULL, 'boss', 'serve:domain_check_list', '2', '', 'f', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=21501);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '21502', '通过', 'sysDomainCheck/treatmentSuccess.html', '域名审核-通过', '215', '', NULL, 'boss', 'serve:domain_check_success', '2', '', 'f', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=21502);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '21503', '失败', 'sysDomainCheck/failureMsg.html', '域名审核-失败', '215', '', NULL, 'boss', 'serve:domain_check_failure', '2', '', 'f', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=21503);


UPDATE "sys_resource" SET "url" = 'vSysDomainCheck/list.html' WHERE ("id" = '201');

UPDATE "sys_resource" SET "url" = 'vSysDomainCheck/list.html' WHERE ("id" = '20104');