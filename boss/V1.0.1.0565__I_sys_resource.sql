-- auto gen by steffan 2018-05-16 16:54:53
-- add by leo
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '90801', '重发', '', '重发', '908', '', '1', 'boss', 'api:resend', '2', '', 'f', 't', 't'
WHERE NOT EXISTS (SELECT ID FROM sys_resource WHERE ID = '90801');


INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '90901', '重发', '', '重发', '909', '', '1', 'boss', 'api:resendBySite', '2', '', 'f', 't', 't'
WHERE NOT EXISTS (SELECT ID FROM sys_resource WHERE ID = '90901');