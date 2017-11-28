-- auto gen by george 2017-10-26 21:55:19
select redo_sqls($$
	alter table pay_account add column random_amount BOOLEAN DEFAULT FALSE;
$$);
COMMENT ON COLUMN pay_account.random_amount IS '是否开启随机额度';