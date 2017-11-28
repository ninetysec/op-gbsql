-- auto gen by tom 2016-03-04 15:28:32
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code",	"order_num", "remark", "parent_code", "active")
SELECT 'notice', 'auto_event_type', 'RESET_PERMISSION_PWD_SUCCESS', NULL, '重置权限密码成功',NULL, 't'
WHERE 'RESET_PERMISSION_PWD_SUCCESS' not in(SELECT dict_code FROM sys_dict WHERE module='notice' and dict_type='auto_event_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code",	"order_num", "remark", "parent_code", "active")
SELECT 'notice', 'auto_event_type', 'RESET_LOGIN_PASSWORD_SUCCESS', NULL, '重置登录密码成功',NULL, 't'
WHERE 'RESET_LOGIN_PASSWORD_SUCCESS' not in(SELECT dict_code FROM sys_dict WHERE module='notice' and dict_type='auto_event_type');