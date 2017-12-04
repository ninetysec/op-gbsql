-- auto gen by cherry 2017-09-26 10:14:50
/*
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
	SELECT '40105', '设置前端展示', 'operation/activity/changeDisplayStatus.html', '设置前端展示功能权限', '401', NULL, NULL, 'mcenter', 'operate:activity_showfront', '2', NULL, 't', 'f', 't'
		 WHERE NOT EXISTS (select id from sys_resource t where t.id = 40105);*/
