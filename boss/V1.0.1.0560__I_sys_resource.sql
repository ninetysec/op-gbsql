-- auto gen by steffan 2018-05-10 11:19:02
-- 新增代理线菜单 insert by leo
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '526', '代理线', 'proxyLine/list.html', '代理线', '5', '', '11', 'boss', 'maintenance:proxyLine', '1', '', 'f', 't', 't'
WHERE NOT EXISTS (SELECT ID FROM sys_resource WHERE ID = '526');