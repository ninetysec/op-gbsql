-- auto gen by cherry 2017-01-17 14:21:20
INSERT INTO "sys_resource"

("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")

SELECT '30204', '平台子账号', 'siteSubAccount/accountList.html', '运营商子账号列表', '302', '', '4', 'boss', 'platform:platformmanage_account', '2', NULL, 'f', 't', 't'

WHERE not EXISTS(SELECT id FROM sys_resource WHERE id = 30204);