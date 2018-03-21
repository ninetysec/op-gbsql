-- auto gen by linsen 2018-03-09 10:10:25
-- 站点管理_站点状态开关权限 by back
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
 SELECT   '30623', '站点管理_站点状态开关', NULL, '站点状态开关', '306', NULL, '21', 'boss', 'platform:site_state_switch', '2', NULL, 'f', 't', 't'
WHERE NOT EXISTS(SELECT id FROM sys_resource WHERE id=30623);
