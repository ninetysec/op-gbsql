-- auto gen by cheery 2015-12-10 08:27:40
WITH role_row as(
	INSERT INTO sys_resource(name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege)
		SELECT '返水统计','report/backwater/reindex.html','统计报表-返水统计',5,'',4,'boss','test:view','1','',FALSE,FALSE
	WHERE 'report/backwater/reindex.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'report/backwater/reindex.html')
	RETURNING id
)
INSERT INTO sys_role_resource (role_id,resource_id)
SELECT (SELECT id FROM sys_role WHERE subsys_code = 'boss' AND code = 'admin'), id FROM role_row;

WITH role_row as(
	INSERT INTO sys_resource(name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege)
		SELECT '返佣统计','report/rebate/rebateIndex.html','统计报表-返水统计',5,'',5,'boss','test:view','1','',FALSE,FALSE
	WHERE 'report/rebate/rebateIndex.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'report/rebate/rebateIndex.html')
	RETURNING id
)
INSERT INTO sys_role_resource (role_id,resource_id)
SELECT (SELECT id FROM sys_role WHERE subsys_code = 'boss' AND code = 'admin'), id FROM role_row;

UPDATE sys_resource SET url = 'report/operate/operateIndex.html', remark = '统计报表-经营报表', sort_num = 3 WHERE id = (SELECT id FROM sys_resource WHERE "name" = '运营报表' AND parent_id = 5 AND subsys_code = 'boss');
UPDATE sys_resource SET url = 'report/log/logList.html', remark = '统计报表-日志查询', sort_num = 6 WHERE "id" = (SELECT "id" FROM sys_resource WHERE parent_id = 5 AND "name" = '日志管理' AND subsys_code = 'boss');