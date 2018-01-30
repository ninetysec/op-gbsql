-- auto gen by george 2018-01-18 10:21:45
delete from sys_resource where id ='61102';

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '61002', '公司入款-编辑', 'payAccount/companyEdit.html', '公司入款-编辑', '610', NULL, NULL, 'mcenter', 'content:payaccount_edit', '2', NULL, 't', 't', 't'
WHERE NOT EXISTS (select id from sys_resource where id = '61002');