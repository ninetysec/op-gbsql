-- auto gen by cherry 2018-01-23 16:21:14
select redo_sqls($$
 ALTER TABLE pay_log ADD COLUMN error_type varchar(32);
$$);

COMMENT ON COLUMN pay_log.error_type is '错误类型';