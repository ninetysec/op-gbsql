-- auto gen by george 2018-01-16 19:51:02
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '20403', '管理游戏标签', 'vGame/manageGameTag.html', '管理游戏标签', '204', NULL, NULL, 'boss', 'serve:apimanage_managetag', '1', NULL, 'f', 't', 't'
WHERE '20403' NOT IN (SELECT id FROM sys_resource where id='20403');