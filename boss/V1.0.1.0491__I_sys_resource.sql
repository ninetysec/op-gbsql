-- auto gen by george 2018-01-14 20:10:02
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '9', 'API', NULL, NULL, NULL, NULL, '9', 'boss', 'boss:api', '1', '', 'f', 't', 't'
WHERE '9' NOT IN (SELECT id FROM sys_resource where id='9');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '901', 'API真人游戏结果', 'liveOrderResult/list.html', 'API真人游戏结果', '9', NULL, '1', 'boss', 'api:live_order_result', '1', NULL, 'f', 't', 't'
WHERE '901' NOT IN (SELECT id FROM sys_resource where id='901');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '902', 'API游戏赛事', 'matchOrder/list.html', 'API游戏赛事', '9', NULL, '2', 'boss', 'api:match_order', '1', NULL, 'f', 't', 't'
WHERE '902' NOT IN (SELECT id FROM sys_resource where id='902');