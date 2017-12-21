-- auto gen by george 2017-11-27 20:45:30

UPDATE "sys_resource" SET "url"='player/addNewPlayer.html' WHERE id='20211';

UPDATE "sys_resource" SET "url"='/player/playerView.html' WHERE id='20208';

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '2020801', '重置登录密码', 'player/resetPwd/index.html', '玩家管理-玩家详细资料-重置登录密码', '20208', '', NULL, 'mcenter', 'role:player_resetLoginPwd', '202', '', 't', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='2020801');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '2020802', '重置安全密码', 'player/resetPwd/index.html', '玩家管理-玩家详细资料-重置安全密码', '20208', '', NULL, 'mcenter', 'role:player_resetpayPwd', '202', '', 't', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='2020802');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '2020803', '查看玩家完整个人信息', '/player/playerView.html', '玩家管理-玩家详细资料-查看玩家完整个人信息', '20208', '', NULL, 'mcenter', 'role:player_personal_detail', '202', '', 't', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='2020803');

