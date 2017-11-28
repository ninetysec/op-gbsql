-- auto gen by cherry 2017-06-07 19:04:43
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
  select '30613', '查看备库地址', '', '查看备库地址', '306', '', '9', 'boss', 'platform:site_backupdb_detail', '2', '', 'f', 't', 't'
  where not EXISTS(SELECT id FROM sys_resource WHERE id='30613');

update sys_resource set name='查看主库地址',remark='查看主库地址'  where id=30612;