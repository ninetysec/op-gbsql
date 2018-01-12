-- auto gen by george 2018-01-10 17:27:52
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '509', '资金查询', 'userPlayerFund/search.html', '日志管理', '5', '', '8', 'mcenter', 'report:userPlayerFund', '1', 'icon-zijinjilu', 't', 'f', 't'
WHERE NOT EXISTS (select id from sys_resource where id = '509');