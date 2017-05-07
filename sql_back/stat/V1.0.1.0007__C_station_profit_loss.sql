-- auto gen by cheery
--创建游戏盈亏账单表
CREATE TABLE IF NOT EXISTS "station_profit_loss" (
"id" SERIAL4 NOT NULL,
"station_bill_id" int4,
"api_id" int4,
"game_id" int4,
"payout" numeric(20,2),
"accounted_proportion" numeric(20,2),
"minimum_guarantee" numeric(20,2),
"profit_loss" numeric(20,2),
"amount_payable" numeric(20,2),
"remark" varchar(1000) COLLATE "default"
)
WITH (OIDS=FALSE)

;
COMMENT ON TABLE "station_profit_loss" IS '游戏盈亏账单--suyj';
COMMENT ON COLUMN "station_profit_loss"."id" IS '主键';
COMMENT ON COLUMN "station_profit_loss"."station_bill_id" IS '站务账单ID';
COMMENT ON COLUMN "station_profit_loss"."api_id" IS 'API';
COMMENT ON COLUMN "station_profit_loss"."game_id" IS '游戏ID';
COMMENT ON COLUMN "station_profit_loss"."payout" IS '派彩';
COMMENT ON COLUMN "station_profit_loss"."accounted_proportion" IS '占成比例';
COMMENT ON COLUMN "station_profit_loss"."minimum_guarantee" IS '保底';
COMMENT ON COLUMN "station_profit_loss"."profit_loss" IS '交易盈亏金额';
COMMENT ON COLUMN "station_profit_loss"."amount_payable" IS '应付金额';
COMMENT ON COLUMN "station_profit_loss"."remark" IS '备注';
