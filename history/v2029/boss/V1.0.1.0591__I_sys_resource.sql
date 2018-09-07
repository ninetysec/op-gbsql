-- auto gen by linsen 2018-08-07 16:26:39
-- 棋牌包网管理 by linsen
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT  '219', '棋牌包网管理', 'chessManager/chessSite.html', '棋牌包网管理', '2', NULL, '19', 'boss', 'chess:chess', '1', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID=219);