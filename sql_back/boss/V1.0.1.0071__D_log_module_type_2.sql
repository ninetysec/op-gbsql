-- auto gen by longer 2016-01-26 20:36:48

--清理之前错误的退出日志
DELETE from sys_audit_log where module_type = '2';