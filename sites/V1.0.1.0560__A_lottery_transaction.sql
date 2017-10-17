-- auto gen by marz 2017-10-17 20:11:37
SELECT redo_sqls($$
ALTER TABLE lottery_transaction ALTER balance TYPE numeric(20,3);
$$);