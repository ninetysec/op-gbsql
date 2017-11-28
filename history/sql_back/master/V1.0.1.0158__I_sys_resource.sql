-- auto gen by fly 2015-11-02 13:51:33
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
 SELECT '2202', '代理列表页', 'topAgentAgent/list.html', '总代中心-代理管理-代理列表', '22', NULL, 1, 'mcenterTopAgent', 'test:view', '1', NULL, 't', 'f'
WHERE 'topAgentAgent/list.html' not in (SELECT url from sys_resource where url = 'topAgentAgent/list.html' );
