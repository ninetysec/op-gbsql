-- auto gen by cherry 2016-03-09 11:47:59
DELETE FROM sys_role_resource WHERE role_id=(SELECT id FROM sys_role WHERE name='admin');

UPDATE sys_user_role SET role_id='-1' WHERE role_id=(SELECT id FROM sys_role WHERE name='admin');

DELETE FROM sys_role WHERE name='admin';

INSERT INTO sys_role ("id", "name", "status", "create_user", "create_time", "update_user", "update_time", "subsys_code", "code", "built_in", "site_id")
SELECT '-1', 'admin', '1', NULL, NULL, NULL, NULL, '', '', 'f', NULL
WHERE '-1' NOT in (SELECT  id FROM sys_role where id='-1');

INSERT INTO sys_role_resource ( "role_id", "resource_id")
SELECT (SELECT id FROM sys_role WHERE name='admin') ,   id FROM sys_resource WHERE subsys_code='mcenter';

