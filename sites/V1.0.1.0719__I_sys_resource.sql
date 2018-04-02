-- auto gen by linsen 2018-03-29 21:34:45
-- 参数页面——查看权限 by back
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT  '7010502', '查看', 'param/parameterSetting.html', '参数页面——查看', '70105', NULL, NULL, 'mcenter', 'system:parameter_setting', '2', NULL, 't', 'f', 't'
WHERE NOT EXISTS(SELECT id FROM sys_resource WHERE id ='7010502');