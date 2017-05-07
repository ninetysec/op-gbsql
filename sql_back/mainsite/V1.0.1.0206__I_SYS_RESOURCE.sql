-- auto gen by tom 2016-01-04 18:03:12
INSERT INTO sys_resource(name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege)
		SELECT '运营商站点维护','sysSite/siteMaintain.html','运营商站点维护',302,'',2,'ccenter','test:view','2','',FALSE,TRUE
	WHERE 'sysSite/siteMaintain.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'sysSite/siteMaintain.html');