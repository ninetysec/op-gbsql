-- auto gen by cherry 2017-10-02 17:24:14
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '30619', '转账上限修改', '', '转账上限修改', '306', '', '17', 'boss', 'siteManage:transfer', '2', '', 'f', 't', 't' WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE permission='siteManage:transfer');

INSERT INTO "gb-boss"."sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '803', '大额监控', 'largeTransactionMonitor/list.html', '大额监控', '8', '', '3', 'boss', 'credit:largeMonitor', '1', '', 'f', 't', 't' WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE id='803');
