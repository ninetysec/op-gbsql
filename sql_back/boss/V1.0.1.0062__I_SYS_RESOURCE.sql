-- auto gen by tom 2016-01-19 09:57:40
INSERT INTO sys_resource(name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
		SELECT '平台运营商联系方式','vPlatformManage/detail/viewMoreContract.html','总控-平台管理',302,'',1,'boss','test:view','2','',FALSE,TRUE,true
	WHERE 'vPlatformManage/detail/viewMoreContract.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'vPlatformManage/detail/viewMoreContract.html');

INSERT INTO sys_resource(name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
		SELECT '平台停用','vPlatformManage/siteStop.html','总控-平台管理-平台停用',302,'',2,'boss','test:view','2','',FALSE,TRUE,true
	WHERE 'vPlatformManage/siteStop.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'vPlatformManage/siteStop.html');
