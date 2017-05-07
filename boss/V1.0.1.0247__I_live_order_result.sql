-- auto gen by root 2016-10-11 20:09:49

CREATE TABLE IF not EXISTS "live_order_result" (
"id" SERIAL4 NOT NULL,
"api_id" int4,
"result_id" varchar(64) COLLATE "default" NOT NULL,
"table_id" varchar(32) COLLATE "default",
"stage" varchar(20) COLLATE "default",
"shootcode" varchar(5) COLLATE "default",
"dealer" varchar(30) COLLATE "default",
"flag" bool DEFAULT false,
"banker_point" varchar(5) COLLATE "default",
"player_point" varchar(5) COLLATE "default",
"cardnum" varchar(10) COLLATE "default",
"pair" varchar(32) COLLATE "default",
"gametype" varchar(10) COLLATE "default",
"gameinformation" varchar(100) COLLATE "default",
"result_json" text COLLATE "default",
"start_time" timestamp(6),
"end_time" timestamp(6),
"create_time" timestamp(6),
"update_time" timestamp(6),
CONSTRAINT "live_order_result_pkey" PRIMARY KEY ("id"),
CONSTRAINT "u_live_order_result" UNIQUE ("api_id", "result_id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "live_order_result" OWNER TO "postgres";

COMMENT ON TABLE "live_order_result" IS 'api真人游戏结果表 ';

COMMENT ON COLUMN "live_order_result"."id" IS '主键';

COMMENT ON COLUMN "live_order_result"."api_id" IS 'api表id';

COMMENT ON COLUMN "live_order_result"."result_id" IS '结果id';

COMMENT ON COLUMN "live_order_result"."table_id" IS '桌号';

COMMENT ON COLUMN "live_order_result"."stage" IS '局号';

COMMENT ON COLUMN "live_order_result"."shootcode" IS '牌靴';

COMMENT ON COLUMN "live_order_result"."dealer" IS '荷官';

COMMENT ON COLUMN "live_order_result"."flag" IS '结算标识';

COMMENT ON COLUMN "live_order_result"."banker_point" IS '庄家点数';

COMMENT ON COLUMN "live_order_result"."player_point" IS '闲家点数';

COMMENT ON COLUMN "live_order_result"."cardnum" IS '牌数目';

COMMENT ON COLUMN "live_order_result"."pair" IS '对子数';

COMMENT ON COLUMN "live_order_result"."gametype" IS '游戏类型';

COMMENT ON COLUMN "live_order_result"."gameinformation" IS '发牌信息';

COMMENT ON COLUMN "live_order_result"."start_time" IS '开始时间';

COMMENT ON COLUMN "live_order_result"."end_time" IS '结束时间';

COMMENT ON COLUMN "live_order_result"."create_time" IS '入库时间';

COMMENT ON COLUMN "live_order_result"."update_time" IS '更新时间';



CREATE INDEX if NOT EXISTS "fk_live_order_result_api_id" ON "live_order_result" USING btree (api_id);

CREATE INDEX if NOT EXISTS  "fk_live_order_result_api_flag" ON "live_order_result" USING btree (flag);

CREATE INDEX if NOT EXISTS  "fk_live_order_result_result_id" ON "live_order_result" USING btree (result_id);

CREATE INDEX if NOT EXISTS "fk_live_order_result_game_bet_time" ON "live_order_result" USING btree (start_time);

CREATE INDEX if NOT EXISTS "fk_live_order_result_payout_time" ON "live_order_result" USING btree (end_time);
