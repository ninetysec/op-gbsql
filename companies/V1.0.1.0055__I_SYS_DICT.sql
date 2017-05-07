-- auto gen by tom 2016-03-17 11:36:09

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'notice', 'auto_event_type', 'FIND_PASSWORD_VERIFICATION_CODE', NULL, '找回密码', NULL, 't'
where 'FIND_PASSWORD_VERIFICATION_CODE' not in(SELECT dict_code FROM sys_dict WHERE module='notice' and dict_type='auto_event_type');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'notice', 'auto_event_type', 'SWITCH', NULL, '站点开关', NULL, 't'
where 'SWITCH' not in(SELECT dict_code FROM sys_dict WHERE module='notice' and dict_type='auto_event_type');
