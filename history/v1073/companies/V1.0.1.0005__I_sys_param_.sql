-- auto gen by cherry 2016-02-05 11:29:17
INSERT INTO sys_param ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  	'setting', 'visit', 	'visit.management.center.prompt', 'true', 'true',	NULL,'是否开启允许访问管理中心的IP,是否需要显示提示语',	NULL,'t',	-1
WHERE 'visit.management.center.prompt' not in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='visit' AND site_id='-1');

INSERT INTO sys_param ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'content', 'domain_type', 'onLinePay', '/onLinePay', '/onLinePay', '5', '支付域名', '', 't', '0'
WHERE 'onLinePay' not in(SELECT param_code FROM sys_param WHERE module='content' AND param_type='domain_type' AND site_id='0');

INSERT INTO notice_email_interface( "id", 	"user_group_type", "user_group_id", "server_address", "server_port", 	"email_account", "account_password", "built_in", "name", 	"create_time", "update_time", 	"send_count", "status", "reply_email_account", "test_email_account")
SELECT '-1', 	'rank', '0', '', 	'', 	'', '┼41f87b2cbe2eb0ec7c09ddf82a7c7c12', 't', 	'默认接口', '2015-08-26 14:14:14', NULL, '0', 	'1', NULL, 	NULL
WHERE '-1' not in(SELECT id FROM notice_email_interface);