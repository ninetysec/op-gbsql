-- auto gen by linsen 2018-03-16 18:11:19
-- pay_account添加自定义账号信息、自定义账号提示字段 by gavin
 select redo_sqls($$
    ALTER TABLE "pay_account" ADD COLUMN "account_information" VARCHAR(30);
		ALTER TABLE "pay_account" ADD COLUMN "account_prompt" VARCHAR(30);
$$);

COMMENT ON COLUMN "pay_account"."account_information" IS '自定义账号信息';
COMMENT ON COLUMN "pay_account"."account_prompt" IS '自定义账号提示';
