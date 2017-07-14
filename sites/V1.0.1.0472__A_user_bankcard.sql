-- auto gen by cherry 2017-07-14 10:36:35
select redo_sqls($$
       ALTER TABLE user_bankcard add COLUMN type varchar(1);
$$);

COMMENT ON COLUMN user_bankcard.type is '银行卡号类型 1-银行卡 2-比特币';