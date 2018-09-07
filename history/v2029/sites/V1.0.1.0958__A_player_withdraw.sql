-- auto gen by steffan 2018-08-20 14:22:44 --增加出款账户，出款渠道，出款商户号字段
 select redo_sqls($$
       ALTER TABLE "player_withdraw" ADD COLUMN "withdraw_account_name" varchar(100);
      $$);

COMMENT ON COLUMN player_withdraw.withdraw_account_name is '出款账户名称,取自withdraw_account表withdraw_name字段';

 select redo_sqls($$
       ALTER TABLE "player_withdraw" ADD COLUMN "bank_code" varchar(50);
      $$);

COMMENT ON COLUMN player_withdraw.bank_code is  '渠道(bank表的bank_name）取自withdraw_account表bank_code字段';

 select redo_sqls($$
       ALTER TABLE "player_withdraw" ADD COLUMN "merchant_account" varchar(200) ;
      $$);

COMMENT ON COLUMN player_withdraw.merchant_account is '商户号账号取自withdraw_account表account字段';



