-- auto gen by tom 2016-01-13 20:27:46
INSERT INTO sys_resource(name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
		SELECT '更换方案','sysSite/changeContractScheme.html','站点-站点管理-详情-站点信息',302,'',3,'ccenter','test:view','2','',FALSE,true,true
	WHERE 'sysSite/changeContractScheme.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'sysSite/changeContractScheme.html')