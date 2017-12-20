-- auto gen by george 2017-12-20 09:27:06
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '522', '存款监控', 'rechargeMonitorParam/list.html', '存款监控参数', '5', NULL, '20', 'boss', 'deposit:monitor', '1', NULL, 'f', 't', 't'
WHERE  NOT EXISTS (SELECT id FROM sys_resource WHERE id =522);
