-- auto gen by cheery 2015-11-10 10:37:15
select redo_sqls($$
    ALTER TABLE "player_transaction" ADD COLUMN "fund_type" varchar(32);
    ALTER TABLE "player_transaction" ADD COLUMN "transaction_way" varchar(32);
    ALTER TABLE "player_transaction" ADD COLUMN "transaction_data" varchar(32);
$$);

COMMENT ON COLUMN "player_transaction"."fund_type" IS '资金类型common.fund_type(公司存款,线上支付,手动存款,手动取款,取款,转入,转出,返水,优惠,推荐)';
COMMENT ON COLUMN "player_transaction"."transaction_way" IS '交易方式common.transaction_way(网银转账,atm转账,柜台转账;综合存款,存款优惠,负数余额归零,取款误操作,其他存款;单次奖励,红利;首存送,存就送,救济金,注册送,有效交易量,自定义活动)';
COMMENT ON COLUMN "player_transaction"."transaction_data" IS '交易数据(根据不同的交易类型,存不同的说明)';

