-- auto gen by george 2017-12-27 16:40:00
INSERT INTO sys_resource (id,name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, privilege, built_in, status)
SELECT '3060814', '站点参数设置', '/site/detail/viewSiteParamSwitch.html', '站点参数设置', '30608', NULL, '14', 'boss', 'platform:view_siteParamSwitch', '2', NULL, 'f', 't', 't'
WHERE NOT EXISTS (SELECT id FROM sys_resource WHERE id=3060814);