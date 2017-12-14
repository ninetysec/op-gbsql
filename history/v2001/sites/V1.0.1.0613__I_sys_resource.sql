-- auto gen by george 2017-11-30 09:06:15
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '2020804', '查看详细', '/player/playerView.html', '玩家管理-查看详细', '20208', '', NULL, 'mcenter', 'role:player_view_detail', '2', '', 't', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='2020804');

update sys_resource set resource_type='2' where resource_type='202' and parent_id=20208;