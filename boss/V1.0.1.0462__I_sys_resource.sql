-- auto gen by george 2017-12-04 09:00:23
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '3060811', '包网方案修改', '', '包网方案修改', '30608', '', '11', 'boss', 'platform:view_changescheme', '2', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE permission='platform:view_changescheme');