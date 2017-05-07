-- auto gen by cherry 2017-02-07 10:59:08
INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")

SELECT '209', 'API架包管理', 'gameApiProvider/list.html', 'API架包管理', '2', NULL, '9', 'boss', 'serve:apiProvider', '1', NULL, 'f', 't', 't'

WHERE NOT EXISTS(SELECT id from sys_resource where id='209');





INSERT INTO "sys_resource"

("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")

SELECT '30205', '设置运营商身份码', 'platform/operatorsManage/resetAuthenticationKey.html', '平台管理-运营商详细', '302', NULL, '5', 'boss', 'platform:company_auth', '2', NULL, 'f', 't', 't'

WHERE not EXISTS(SELECT id FROM sys_resource WHERE id = 30205);



INSERT INTO "sys_resource"

("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")

SELECT '30603', '设置站长身份码', 'vSiteMasterManage/resetAuthenticationKey.html', '站点管理-站长详细', '306', NULL, '3', 'boss', 'platform:master_auth', '2', NULL, 'f', 't', 't'

WHERE not EXISTS(SELECT id FROM sys_resource WHERE id = 30603);



update sys_resource set name='设置运营商子账号身份码' , url='platformSubAccount/resetAuthenticationKey.html' where id=30204;

update sys_resource set name='设置站长子账号身份码' , url='siteSubAccount/resetAuthenticationKey.html' where id=30602;