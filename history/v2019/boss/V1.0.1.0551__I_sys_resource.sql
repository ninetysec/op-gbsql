-- auto gen by linsen 2018-04-23 20:41:46
-- 支付日志-查看参数和查看权限 by leo
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '51402', '查看参数', '', '支付日志-查看参数', '514', NULL, '02', 'boss', 'paylog:view', '2', NULL, 'f', 't', 't'
WHERE NOT EXISTS (SELECT ID FROM sys_resource WHERE permission = 'paylog:view');


INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '51401', '查看', 'payLog/payLogList.html', '支付日志-查看', '514', NULL, '01', 'boss', 'paylog:list', '2', NULL, 'f', 't', 't'
WHERE NOT EXISTS (SELECT ID FROM sys_resource WHERE permission = 'paylog:list');
