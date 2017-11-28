-- auto gen by bruce 2017-04-05 16:48:48
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code",
"permission", "resource_type", "icon", "built_in", "privilege", "status") SELECT '3305', '返佣明细',
'report/agentRebate/list.html', '报表记录-返佣明细', '33', '', '4', 'mcenterAgent', 'report:agentRebate', '1', NULL, 't', 'f',
't' where '3305' not in (SELECT id FROM sys_resource WHERE id='3305');
