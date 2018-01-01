-- auto gen by george 2017-12-06 16:51:35

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '3060813', '银行卡信息', '/site/detail/viewUserBankCard.html', '银行卡信息', '30608', NULL, '13', 'boss', 'platform:view_userBankCard', '2', NULL, 'f', 't', 't'
WHERE NOT EXISTS ( SELECT id FROM sys_resource WHERE id=3060813);