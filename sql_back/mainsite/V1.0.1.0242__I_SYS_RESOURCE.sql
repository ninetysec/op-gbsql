-- auto gen by tom 2016-01-20 09:24:51
INSERT INTO sys_resource(name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
		SELECT '站点管理站点商联系方式','site/detail/viewMoreSiteContacts.html','运营商-站点管理-详情',302,'',5,'ccenter','test:view','2','',FALSE,TRUE,true
	WHERE 'site/detail/viewMoreSiteContacts.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'site/detail/viewMoreSiteContacts.html');

INSERT INTO sys_resource(name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
		SELECT '站点管理站点停用','sysSite/siteStop.html','运营商-站点管理-站点停用',302,'',6,'ccenter','test:view','2','',FALSE,TRUE,true
	WHERE 'sysSite/siteStop.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'sysSite/siteStop.html');