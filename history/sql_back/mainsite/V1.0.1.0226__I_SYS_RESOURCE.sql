-- auto gen by tom 2016-01-10 17:16:36
INSERT INTO sys_resource(name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
		SELECT '站长详细资料','vSiteMasterManage/viewMoreDetail.html','站点-站长管理',301,'',1,'ccenter','test:view','2','',FALSE,true,true
	WHERE 'vSiteMasterManage/viewMoreDetail.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'vSiteMasterManage/viewMoreDetail.html')