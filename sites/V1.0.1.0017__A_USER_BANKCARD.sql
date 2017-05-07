-- auto gen by eagle 2016-02-23 11:51:34
select redo_sqls($$
   ALTER TABLE user_bankcard ADD COLUMN custom_bank_name CHARACTER VARYING(32);
  $$);
COMMENT ON COLUMN "user_bankcard"."custom_bank_name" IS '没有匹配到银行自行输入的银行信息';
