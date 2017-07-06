-- auto gen by cherry 2017-07-06 10:49:37

DELETE from sys_resource where url='lottery/odds/index.html' and parent_id=7;
DELETE from sys_resource where url='lottery/quotas/index.html' and parent_id=7;

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '707', '赔率设置', 'lottery/odds/index.html', '赔率设置', '7', NULL, '7', 'boss', 'lottery:lottery_odds', '1', NULL, 'f', 't', 't' WHERE NOT EXISTS (SELECT id FROM sys_resource where url='lottery/odds/index.html' and parent_id=7);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '708', '限额设置', 'lottery/quotas/index.html', '限额设置', '7', NULL, '8', 'boss', 'lottery:lottery_quotas', '1', NULL, 'f', 't', 't' WHERE NOT EXISTS (SELECT id FROM sys_resource where url='lottery/quotas/index.html' and parent_id=7);