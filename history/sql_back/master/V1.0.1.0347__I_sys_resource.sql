-- auto gen by orange 2016-01-24 18:10:58
INSERT INTO sys_resource(name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
		SELECT '玩家详细资料','player/playerViewDetail.html','玩家管理-玩家详细资料（显示隐藏字段）',202,'',1,'mcenter','test:view','2','',FALSE,true,true
	WHERE 'player/playerViewDetail.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'player/playerViewDetail.html')