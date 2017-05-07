-- auto gen by cherry 2017-01-12 15:12:20
INSERT INTO "sys_resource"

("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")

SELECT '30602', '站点子账号', '/siteSubAccount/accountList.html', '站点子账号列表', '306', '', '2', 'boss', 'platform:subaccount', '2', NULL, 'f', 't', 't'

WHERE not EXISTS(SELECT id FROM sys_resource WHERE id = 30602);