-- auto gen by linsen 2018-05-01 10:31:44
-- 删除API权限 by carl
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select '91402', '删除API', 'VPlayerApi/deletePlayerApiAccount.html', '删除API', '914', '', '2', 'boss', 'api:deletePlayerApiAccount', '2', '', 'f', 't', 't'
where not EXISTS (select id from sys_resource where id = 91402);