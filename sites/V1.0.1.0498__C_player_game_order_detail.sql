-- auto gen by tony 2017-08-07 11:44:15
--Drop TABLE IF EXISTS "player_game_order_detail";
CREATE TABLE IF NOT EXISTS "player_game_order_detail" (
"id" serial NOT NULL,
"api_id"  int4 NOT NULL,
"bet_id" varchar(64) COLLATE "default" NOT NULL,
"player_id" int4 NOT NULL,
"order_state" varchar(32) COLLATE "default",
"payout_time" timestamp(6),
"bet_time" timestamp(6),
"result_json" text COLLATE "default",
"action_id_json" text COLLATE "default",
CONSTRAINT "player_game_order_detail_pkey" PRIMARY KEY ("id"),
CONSTRAINT "player_game_order_detail_ukey" UNIQUE ("api_id", "bet_id")
);

COMMENT ON TABLE "player_game_order_detail" IS '玩家游戏下单详细表 -- cherry';
COMMENT ON COLUMN "player_game_order_detail"."id" IS '主键';
COMMENT ON COLUMN "player_game_order_detail"."api_id" IS 'api表id';
COMMENT ON COLUMN "player_game_order_detail"."bet_id" IS '注单号码';
COMMENT ON COLUMN "player_game_order"."player_id" IS '玩家外键';
COMMENT ON COLUMN "player_game_order"."order_state" IS '下单状态：未结算、已结算、订单取消 字典：game order_state';
COMMENT ON COLUMN "player_game_order"."bet_time" IS '下注时间';
COMMENT ON COLUMN "player_game_order"."payout_time" IS '派彩时间';
COMMENT ON COLUMN "player_game_order_detail"."result_json" IS '游戏结果json';
COMMENT ON COLUMN "player_game_order_detail"."action_id_json" IS 'action_id_json，格式为action_id:profitAmount';
