-- auto gen by george 2017-12-03 11:39:12
INSERT INTO sys_resource("id", "name", url, remark, parent_id, "structure", sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
SELECT 4001, '财务中心', NULL, '财务中心菜单分类', NULL, NULL, 1, 'pcenter', 'pcenter:finance', 1, 'capital', TRUE, FALSE, TRUE
 WHERE 4001 NOT IN (SELECT id FROM sys_resource WHERE id=4001);

INSERT INTO sys_resource("id", "name", url, remark, parent_id, "structure", sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
SELECT 4002, '个人中心', NULL, '个人中心菜单分类', NULL, NULL, 2, 'pcenter', 'pcenter:personal', 1, 'capital', TRUE, FALSE, TRUE
 WHERE 4002 NOT IN (SELECT id FROM sys_resource WHERE id=4002);

update sys_resource set parent_id=4001 where id in (41,42,43,44,45,46);
update sys_resource set parent_id=4002 where id in (47,48,49);