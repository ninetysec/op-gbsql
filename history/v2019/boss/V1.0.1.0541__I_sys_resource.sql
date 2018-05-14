-- auto gen by linsen 2018-04-03 09:59:00
-- 在线人数菜单 by back
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '218', '在线人数', 'siteOnlineAccount/list.html', '在线人数列表', '2', NULL, '18', 'boss', 'service:onlinePeople', '1', NULL, 'f', 't', 't'
WHERE NOT EXISTS (SELECT id FROM sys_resource WHERE id =218);