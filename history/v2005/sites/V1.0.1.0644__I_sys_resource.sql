-- auto gen by george 2017-12-26 17:58:41
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '40105', '内定', 'operation/activity/setDefaultWin.html', '活动管理-内定', '401', '', NULL, 'mcenter', 'operate:activity_defaultSet', '2', '', 't', 'f', 't'
WHERE NOT EXISTS(SELECT id FROM sys_resource WHERE id ='40105');

