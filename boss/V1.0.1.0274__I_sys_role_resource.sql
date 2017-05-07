-- auto gen by brave 2016-12-30 07:41:17
INSERT INTO "sys_role_resource"
("id", "role_id", "resource_id")
SELECT '1710', '1', '409'
WHERE not EXISTS(SELECT id FROM sys_role_resource WHERE resource_id = 409);
