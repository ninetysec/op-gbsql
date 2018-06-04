-- auto gen by linsen 2018-05-09 17:25:01
-- 编辑API代理配置 by leo
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '21201', '编辑API代理配置', '', '编辑API代理配置信息', '212', '', '01', 'boss', 'api:agent_conf', '2', '', 'f', 't', 't'
WHERE NOT EXISTS (SELECT ID FROM sys_resource WHERE id=21201);