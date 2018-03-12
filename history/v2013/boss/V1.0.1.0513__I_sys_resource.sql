-- auto gen by linsen 2018-02-02 17:44:16
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") SELECT
'523', '支付日志分析', 'payLogAnalyze/init.html', '支付日志分析', '10', NULL, '21', 'boss', 'maintenance:payLogAnalyze', '1', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE NAME='支付日志分析' AND url='payLogAnalyze/init.html');
