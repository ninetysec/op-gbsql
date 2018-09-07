-- auto gen by linsen 2018-08-20 14:01:00
-- 站点开关设置权限 by martin
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, privilege, built_in, status)
select 3060816, '站点开关设置', '/sysSiteSwitch/viewSiteSwitch.html', '站点开关设置', 30608, NULL, 16, 'boss', 'platform:view_siteSwitch', 2, NULL, FALSE, TRUE, TRUE where not exists(select id from sys_resource where id = 3060816);