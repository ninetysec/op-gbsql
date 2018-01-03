-- auto gen by george 2017-12-05 21:50:47
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '39', '在线玩家', 'vPlayerOnline/list.html', '在线玩家', NULL, '', '9', 'mcenterAgent', 'player:playerOnline', '1', 'icon-zaixianwanjia', 't', 'f', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='39');