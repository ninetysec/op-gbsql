-- auto gen by kobe 2016-09-03 11:08:41
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") SELECT '512', '注单监控', 'apiOrderLog/queryApiOrderLog.html', '注单监控', '5', NULL, '12', 'boss', 'maintenance:order', '1', NULL, 'f', 't', 't' WHERE  NOT EXISTS (SELECT id FROM sys_resource WHERE id = 512) ;

