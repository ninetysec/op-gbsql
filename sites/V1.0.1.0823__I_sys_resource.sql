-- auto gen by steffan 2018-05-15 19:23:25
-- 返佣明细菜单： add by kobe
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '2304', '返佣明细', 'rebateAgent/list.html', '报表记录-返佣明细', '23', '', '4', 'mcenterTopAgent', 'report:topAgentRebate', '1', NULL, 't', 'f', 't'
WHERE  NOT exists (SELECT ID FROM sys_resource WHERE ID = 2304 );