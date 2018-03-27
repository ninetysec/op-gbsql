-- auto gen by linsen 2018-01-31 09:12:57
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '10', '支付', '', '支付', NULL, NULL, '10', 'boss', 'boss:payment', '1', '', 'f', 't', 't'
WHERE NOT EXISTS(SELECT id FROM sys_resource WHERE id='10');

UPDATE "sys_resource" SET "parent_id"='10'  WHERE ("id"='205');

UPDATE "sys_resource" SET "parent_id"='10'  WHERE ("id"='210');

UPDATE "sys_resource" SET "parent_id"='10'  WHERE ("id"='514');

UPDATE "sys_resource" SET "parent_id"='10'  WHERE ("id"='515');

UPDATE "sys_resource" SET "parent_id"='10'  WHERE ("id"='522');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '1001', '停用收款日志历史记录', 'payAccountDisableLog/list.html', '停用收款日志记录', '10', NULL, '1', 'boss', 'payAccount:disableLog', '1', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT id FROM sys_resource WHERE id='1001');