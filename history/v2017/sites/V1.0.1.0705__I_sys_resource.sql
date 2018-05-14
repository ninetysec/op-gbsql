-- auto gen by linsen 2018-03-12 23:09:36
--站长中心风控审核数据菜单 add by steffan

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
 select '209', '风控数据', 'riskManagementSite/list.html', '站长中心风控数据', '2', NULL, '9', 'mcenter', 'role:riskmanagementsite', '1', 'icon-dailixinjin', 't', 'f', 't'
where not EXISTS (SELECT id FROM sys_resource where id='209' );
