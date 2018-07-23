-- auto gen by linsen 2018-06-14 14:48:16
-- 更新短信接口账号，密码长度限制 by carl
SELECT redo_sqls($$
	ALTER TABLE sms_interface alter COLUMN username type character varying(64);
	ALTER TABLE sms_interface alter COLUMN password type character varying(64);
$$);