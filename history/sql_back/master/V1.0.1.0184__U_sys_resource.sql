-- auto gen by fly 2015-11-11 14:48:39
UPDATE sys_resource SET url = 'report/log/logList.html' WHERE "id" = (SELECT "id" FROM sys_resource WHERE name = '日志管理' AND subsys_code = 'mcenter');
