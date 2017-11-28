-- auto gen by tom 2016-01-15 09:27:43
INSERT INTO sys_resource(name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
		SELECT '站长账号停用','vMasterManage/disabledAccount.html','站点-站长管理',301,'',4,'ccenter','test:view','2','',FALSE,true,true
	WHERE 'vMasterManage/disabledAccount.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'vMasterManage/disabledAccount.html');

INSERT INTO sys_resource(name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
		SELECT '站点玩家导入开启关闭','site/detail/operateImportPlayers.html','站点-站点管理',302,'',4,'ccenter','test:view','2','',FALSE,true,true
	WHERE 'site/detail/operateImportPlayers.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'site/detail/operateImportPlayers.html');