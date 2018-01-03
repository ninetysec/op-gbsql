-- auto gen by george 2017-11-30 16:20:26
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
 SELECT '2020805', '查看玩家完整联系信息', 'player/playerViewDetail.html', '玩家管理-玩家详细资料-查看玩家完整联系信息', '20208', '', NULL, 'mcenter', 'role:player_personal_detail', '2', '', 't', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='2020805');