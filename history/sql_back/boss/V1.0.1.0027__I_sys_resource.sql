-- auto gen by cheery 2015-12-15 08:51:42
	INSERT INTO sys_resource(id,name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege)
		SELECT '3011', '运营商取消冻结','platform/operatorsManage/saveCancelFreeze.html','运营商取消冻结',301,'',1,'boss','test:view','2','',FALSE,TRUE
	WHERE 'platform/operatorsManage/saveCancelFreeze.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'platform/operatorsManage/saveCancelFreeze.html');

		INSERT INTO sys_resource(id,name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege)
		SELECT '3012', '停用运营商','platform/operatorsManage/confirmDisabled.html','停用运营商',301,'',2,'boss','test:view','2','',FALSE,TRUE
	WHERE 'platform/operatorsManage/confirmDisabled.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'platform/operatorsManage/confirmDisabled.html');
