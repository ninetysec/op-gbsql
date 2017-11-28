-- auto gen by george 2017-11-17 15:47:28
select redo_sqls ($$
alter table credit_account add column off_amount NUMERIC(20,2) DEFAULT 0; $$);
COMMENT ON COLUMN credit_account.off_amount IS '账户停用金额';