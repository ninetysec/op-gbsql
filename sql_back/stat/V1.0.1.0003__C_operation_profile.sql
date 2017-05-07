-- auto gen by cheery
--创建运营概况表
CREATE TABLE IF NOT EXISTS "operation_profile" (
"id" SERIAL4 NOT NULL,
"center_id"  int4,
"master_id"  int4,
"site_id"  int4,
"statistics_time" timestamp,
"new_player" int4,
"new_player_deposit" int4,
"new_agent" int4,
"deposit_amount" numeric(20,2),
"deposit_player" int4,
"withdrawal_amount" numeric(20,2),
"withdrawal_player" int4,
"effective_transaction_volume" numeric(20,2),
"transaction_player" int4,
"transaction_profit_loss" numeric(20,2),
PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;
ALTER TABLE "operation_profile" OWNER TO "postgres";
COMMENT ON TABLE "operation_profile" IS '运营概况表--suyj';
COMMENT ON COLUMN "operation_profile"."id" IS '主键';
COMMENT ON COLUMN "operation_profile"."center_id" IS '运营商ID';
COMMENT ON COLUMN "operation_profile"."master_id" IS '站长ID';
COMMENT ON COLUMN "operation_profile"."site_id" IS '站点ID';
COMMENT ON COLUMN "operation_profile"."statistics_time" IS '统计时间,保存到天';
COMMENT ON COLUMN "operation_profile"."new_player" IS '当天新增玩家数';
COMMENT ON COLUMN "operation_profile"."new_player_deposit" IS '当天新增玩家的存款人数';
COMMENT ON COLUMN "operation_profile"."new_agent" IS '当天新增代理数';
COMMENT ON COLUMN "operation_profile"."deposit_amount" IS '当天存款金额';
COMMENT ON COLUMN "operation_profile"."deposit_player" IS '当天存款的玩家数';
COMMENT ON COLUMN "operation_profile"."withdrawal_amount" IS '当天取款金额';
COMMENT ON COLUMN "operation_profile"."withdrawal_player" IS '当天取款的玩家数';
COMMENT ON COLUMN "operation_profile"."effective_transaction_volume" IS '当天有效交易量';
COMMENT ON COLUMN "operation_profile"."transaction_player" IS '当天交易玩家数';
COMMENT ON COLUMN "operation_profile"."transaction_profit_loss" IS '当天交易盈亏';
