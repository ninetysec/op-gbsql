-- auto gen by george 2017-11-20 10:23:39
INSERT INTO"sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '804', '清算记录', 'creditClearingRecord/init.html', '月度清算记录', '8', NULL, '4', 'boss', 'credit:clearingrecord', '1', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT id FROM sys_resource WHERE id=804);