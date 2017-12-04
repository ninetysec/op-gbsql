-- auto gen by cherry 2017-09-18 21:02:30
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status") SELECT '20211', '新增玩家', '', '新增玩家', '202', '', NULL, 'mcenter', 'role:player_add', '2', '', 't', 'f', 't' WHERE 20211 NOT IN(SELECT id FROM sys_resource WHERE id=20211);
