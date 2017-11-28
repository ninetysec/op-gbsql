-- auto gen by cherry 2017-08-09 20:21:26

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") SELECT '518', '数字货币信息', 'digiccyTransaction/info.html', '数字货币信息展示', '5', '', '18', 'boss', 'maintenance:reportLog', '1', '', 'f', 't', 't' WHERE 518 NOT IN(SELECT id FROM sys_resource WHERE id=518);
