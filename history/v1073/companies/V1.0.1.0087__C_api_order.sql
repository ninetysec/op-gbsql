-- auto gen by admin 2016-04-29 21:17:57
CREATE TABLE IF not EXISTS "api_order" (
"id" SERIAL4 NOT NULL,
"bet_id" varchar(64)  NOT NULL,
"game_code" varchar(64)  NOT NULL,
"account" varchar(32)  NOT NULL,
"site_id" int4,
"single_amount" numeric(20,2)  NOT NULL,
bet_time TIMESTAMP(6),
"profit_amount" numeric(20,2),
"payout_time" timestamp(6),
"is_profit_loss" bool,
"effective_trade_amount" numeric(20,2),
"order_state" varchar(32) ,
"currency_code" varchar(30) ,
"result_json" text ,
"action_id_json" text ,
"winning_amount" numeric(20,2),
"winning_flag" bool,
"winning_time" timestamp(6),
"game_id" int4,
"game_type" varchar(32) ,
"api_type_id" int4,
"api_id" int4,
"create_time" timestamp(6),
CONSTRAINT "api_order_pkey" PRIMARY KEY ("id"),
CONSTRAINT "u_api_order" UNIQUE ("api_id", "bet_id")
)
WITH (OIDS=FALSE);
COMMENT ON TABLE "api_order" IS '玩家游戏投注表 ';
COMMENT ON COLUMN "api_order"."id" IS '主键';
COMMENT ON COLUMN "api_order"."bet_id" IS '注单号码';
COMMENT ON COLUMN "api_order"."game_code" IS '游戏code';
COMMENT ON COLUMN "api_order"."account" IS 'api账号';
COMMENT ON COLUMN "api_order"."site_id" IS '站点id';
COMMENT ON COLUMN "api_order"."single_amount" IS '投注金额 ';
COMMENT ON COLUMN "api_order"."profit_amount" IS '派彩金额';
COMMENT ON COLUMN "api_order"."payout_time" IS '派彩时间';
COMMENT ON COLUMN "api_order"."is_profit_loss" IS '是否有盈亏：t-有盈亏 f-和局';
COMMENT ON COLUMN "api_order"."effective_trade_amount" IS '有效交易量';
COMMENT ON COLUMN "api_order"."order_state" IS 'game.order_state:未结算,已结算,订单取消';
COMMENT ON COLUMN "api_order"."currency_code" IS '币种';
COMMENT ON COLUMN "api_order"."winning_amount" IS '中奖金额';
COMMENT ON COLUMN "api_order"."winning_flag" IS '中奖标识';
COMMENT ON COLUMN "api_order"."winning_time" IS '中奖时间';
COMMENT ON COLUMN "api_order"."result_json" IS '游戏结果json';
COMMENT ON COLUMN "api_order"."action_id_json" IS '爆点记录的action_id,格式为action_id:profitAmount';
COMMENT ON COLUMN "api_order"."game_id" IS '游戏外键';
COMMENT ON COLUMN "api_order"."game_type" IS '游戏分类';
COMMENT ON COLUMN "api_order"."api_type_id" IS 'api分类';
COMMENT ON COLUMN "api_order"."api_id" IS 'api表id';
COMMENT ON COLUMN "api_order"."create_time" IS '入库时间';
COMMENT on COLUMN api_order.bet_time is '投注时间';

DROP INDEX if EXISTS fk_api_order_bet_id;
DROP INDEX if EXISTS fk_api_order_game_code;
DROP INDEX IF EXISTS fk_api_order_site_id;
DROP INDEX if EXISTS fk_api_order_payout_time;
DROP INDEX if EXISTS fk_api_order_api_id;
DROP INDEX IF EXISTS fk_api_order_api_type_id;
DROP INDEX if EXISTS fk_api_order_game_id;
DROP INDEX if EXISTS fk_api_order_game_bet_time;

CREATE INDEX "fk_api_order_bet_id" ON "api_order" USING btree (bet_id);
CREATE INDEX "fk_api_order_game_code" ON "api_order" USING btree (game_code);
CREATE INDEX "fk_api_order_site_id" ON "api_order" USING btree (site_id);
CREATE INDEX "fk_api_order_payout_time" ON "api_order" USING btree (payout_time);
CREATE INDEX "fk_api_order_api_id" ON "api_order" USING btree (api_id);
CREATE INDEX "fk_api_order_api_type_id" ON "api_order" USING btree (api_type_id);
CREATE INDEX "fk_api_order_game_id" ON "api_order" USING btree (game_id);
CREATE INDEX  fk_api_order_game_bet_time on api_order USING btree(bet_time);