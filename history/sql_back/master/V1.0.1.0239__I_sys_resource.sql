-- auto gen by cheery 2015-11-27 16:00:14
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
    SELECT '61203', '域名管理-默认编辑', 'content/sysDomain/mainManagerEdit.html', '域名管理-默认编辑', '612', '', NULL, 'mcenter', 'test:view', '2', '', 't', 't'
    WHERE '61203' NOT IN (SELECT id FROM sys_resource WHERE id = '61203');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege")
SELECT '61204', '域名管理-编辑', 'content/sysDomain/domainEdit.html', '域名管理-编辑', '612', '', NULL, 'mcenter', 'test:view', '2', '', 't', 't'
WHERE '61204' NOT IN (SELECT id FROM sys_resource WHERE id='61204');
