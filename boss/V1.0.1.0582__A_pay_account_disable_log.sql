-- auto gen by linsen 2018-07-02 20:30:02
-- pay_account_disable_log表添加字段 by cherry
select redo_sqls($$
	ALTER TABLE pay_account_disable_log ADD COLUMN pay_name varchar(256);
$$);

COMMENT ON COLUMN pay_account_disable_log.pay_name is '账户名称';