-- auto gen by linsen 2018-07-23 20:27:02
-- 棋牌菜单 by linsen
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '12', '棋牌', '', '', NULL, '', '11', 'mcenter', 'mcenter:chess', '1', '', 't', 'f', 'f'
WHERE NOT EXISTS (SELECT id FROM sys_resource WHERE id='12');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '1201', '游戏管理', 'chessSiteGame/gameManager.html', '棋牌-游戏管理', '12', NULL, '1', 'mcenter', 'chess:ganmeManager', '1', '', 't', 'f', 't'
WHERE NOT EXISTS (SELECT id FROM sys_resource WHERE id='1201');
