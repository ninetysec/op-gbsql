-- auto gen by george 2018-01-26 17:58:28
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '51501', '查看', 'payAccountCollection/payAccountList.html', '查看', '515', NULL, '1', 'boss', 'payAccount:list', '2', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT id FROM sys_resource WHERE id='51501');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '51502', '查看详情', 'payAccountCollection/view.html', '查看线上支付账户详情', '515', NULL, '2', 'boss', 'payAccount:view', '2', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT id FROM sys_resource WHERE id='51502');
