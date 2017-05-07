-- auto gen by brave 2017-01-07 07:47:28
INSERT INTO "sys_resource"
("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '30601', '站点统计', '/statSiteOrder/list.html', '平台管理-站点管理-站点统计', '306', '', '1', 'boss', 'platform:platformmanage_statsite', '2', '', 'f', 't', 't'
WHERE not EXISTS(SELECT id FROM sys_resource WHERE id = 30601);