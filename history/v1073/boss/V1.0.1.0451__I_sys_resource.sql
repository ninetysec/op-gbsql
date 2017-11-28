-- auto gen by george 2017-11-20 21:49:56
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '30620', '导入玩家', '', '启用禁用导入玩家', '306', '', '20', 'boss', 'platform:site_is_enable', '2', '', 'f', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='30620');