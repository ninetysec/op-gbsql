-- auto gen by linsen 2018-03-09 10:48:26
-- 游戏数据同步进度　by pack
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '903', '游戏数据同步进度', 'apiGameLog/list.html', '游戏数据同步进度', '9', NULL, '3', 'boss', 'api:api_game_log', '1', NULL, 'f', 't', 't'
WHERE '903' NOT IN (SELECT id FROM sys_resource where id='903');