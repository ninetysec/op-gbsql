-- auto gen by linsen 2018-03-27 11:42:47
--站长中心  系统设置 --前端展示，参数设置 权限  by back

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '70104', '前端展示', 'param/frontEnd.html', '系统设置-前端展示', '701', NULL, NULL, 'mcenter', 'system:frontend_setting', '2', NULL, 't', 't', 't'
WHERE NOT EXISTS( SELECT id FROM sys_resource WHERE id =70104);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT  '70105', '参数设置', 'param/parameterSetting.html', '系统设置-参数设置', '701', NULL, NULL, 'mcenter', 'system:parameter_setting', '2', NULL, 't', 't', 't'
WHERE NOT EXISTS (SELECT id FROM sys_resource WHERE id=70105);


--参数设置--电销开关权限
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT   '7010501', '电销参数设置', NULL, '电销开关', '70105', NULL, NULL, 'mcenter', 'system:electricpin_switch', '2', NULL, 't', 't', 't'
WHERE NOT EXISTS (SELECT id FROM sys_resource WHERE id=7010501);