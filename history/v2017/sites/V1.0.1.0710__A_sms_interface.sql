-- auto gen by linsen 2018-03-20 10:14:16
-- sms_interface表的request_url字段删除非空约束 by carl
SELECT redo_sqls($$
	alter table sms_interface alter COLUMN  request_url drop not null;
$$);
