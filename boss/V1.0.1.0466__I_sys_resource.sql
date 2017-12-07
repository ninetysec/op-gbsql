-- auto gen by george 2017-12-07 17:57:04
INSERT INTO sys_resource (id,name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, privilege, built_in, status)
SELECT '3060812', '站点参数', '/site/detail/viewSiteParam.html', '站点参数', '30608', '', '12', 'boss', 'platform:view_siteParam', '2', NULL, 'f', 't', 't'
 WHERE NOT EXISTS (SELECT id FROM sys_resource  WHERE  id=3060812) ;