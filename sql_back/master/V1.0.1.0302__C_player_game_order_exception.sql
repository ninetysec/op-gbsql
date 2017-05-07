-- auto gen by cheery 2015-12-30 20:51:41
CREATE TABLE IF NOT EXISTS "player_game_order_exception" (
"id" int4 NOT NULL,
"game_id" int4,
"player_id" int4,
"order_no" varchar(50) COLLATE "default",
"create_time" timestamp(6),
"game_result" varchar(60) COLLATE "default",
"single_amount" numeric(20,2),
"profit_amount" numeric(20,2),
"brokerage_amount" numeric(20,2),
"is_profit_loss" bool,
"payout_time" timestamp(6),
"result_json" text COLLATE "default",
"effective_trade_amount" numeric(20,2),
"api_id" int4,
"order_state" varchar(32) COLLATE "default",
"game_type" varchar(32) COLLATE "default",
"currency_code" varchar(30) COLLATE "default",
"api_type_id" int4,
"account" varchar(32) COLLATE "default",
"bet_id" varchar(64) COLLATE "default",
PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "player_game_order_exception" OWNER TO "postgres";

COMMENT ON TABLE "player_game_order_exception" IS '玩家游戏下单错误表 -- cherry';

COMMENT ON COLUMN "player_game_order_exception"."game_id" IS '游戏外键';

COMMENT ON COLUMN "player_game_order_exception"."player_id" IS '玩家外键';

COMMENT ON COLUMN "player_game_order_exception"."order_no" IS '订单号';

COMMENT ON COLUMN "player_game_order_exception"."create_time" IS '创建时间';

COMMENT ON COLUMN "player_game_order_exception"."game_result" IS '游戏结果';

COMMENT ON COLUMN "player_game_order_exception"."single_amount" IS '下单金额 (交易量)';

COMMENT ON COLUMN "player_game_order_exception"."profit_amount" IS '盈亏结果金额（派彩）';

COMMENT ON COLUMN "player_game_order_exception"."brokerage_amount" IS '退佣金额';

COMMENT ON COLUMN "player_game_order_exception"."is_profit_loss" IS '是否有盈亏：t-有盈亏 f-和局';

COMMENT ON COLUMN "player_game_order_exception"."payout_time" IS '派彩时间';

COMMENT ON COLUMN "player_game_order_exception"."result_json" IS '游戏结果json';

COMMENT ON COLUMN "player_game_order_exception"."effective_trade_amount" IS '有效交易量';

COMMENT ON COLUMN "player_game_order_exception"."api_id" IS 'api表id';

COMMENT ON COLUMN "player_game_order_exception"."order_state" IS '下单状态：未结算、已结算、订单取消 字典：game order_state';

COMMENT ON COLUMN "player_game_order_exception"."currency_code" IS '币种';

COMMENT ON COLUMN "player_game_order_exception"."api_type_id" IS 'api分类';

COMMENT ON COLUMN "player_game_order_exception"."account" IS '账号';

COMMENT ON COLUMN "player_game_order_exception"."bet_id" IS '注单号码';