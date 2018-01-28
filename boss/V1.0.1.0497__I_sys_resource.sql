-- auto gen by george 2018-01-22 21:06:16
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
 SELECT '80501', '查看', 'vSysCredit/list.html', '买分管理查看', '805', '', '1', 'boss', 'credit:viewable', '2', '', 'f', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID = '80501');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
 SELECT '80502', '可操作', 'vSysCredit/list.html', '买分管理可操作', '805', '', '2', 'boss', 'credit:operable', '2', '', 'f', 't', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID = '80502');