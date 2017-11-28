-- auto gen by loong 2015-10-19 10:03:43
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
 SELECT '127', '账号停用', 'player/view/disabledAccount.html', NULL, '202', NULL, NULL, 'mcenter', 'test:view', '2', NULL, 't', 't'
WHERE 'player/view/disabledAccount.html' not in (SELECT url from sys_resource where url = 'player/view/disabledAccount.html' );

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
 SELECT '128', '强制踢出', 'player/view/offlineForced.html', NULL, '202', NULL, NULL, 'mcenter', 'test:view', '2', NULL, 't', 't'
WHERE 'player/view/offlineForced.html' not in (SELECT url from sys_resource where url = 'player/view/offlineForced.html' );

