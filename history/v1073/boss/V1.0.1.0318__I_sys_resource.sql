-- auto gen by bill 2017-04-06 10:00:00
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
 SELECT '610', 'APP更新管理', 'appUpdate/list.html', 'APP更新管理', '6', NULL, '8', 'boss', 'system:appUpdate', '1', NULL, 'f', 't', 't'
  where '610' not in (SELECT id FROM sys_resource WHERE id='610');