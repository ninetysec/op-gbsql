-- auto gen by linsen 2018-03-13 15:53:26

--系统目录下添加 站点APP更新管理 菜单 by carl
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select  '613', '站点APP更新管理', 'siteAppUpdate/list.html', '站点APP更新管理', '6', NULL, '10', 'boss', 'system:siteAppUpdate', '1', NULL, 'f', 't', 't'
where 'siteAppUpdate/list.html' not in (select url from sys_resource where url = 'siteAppUpdate/list.html');