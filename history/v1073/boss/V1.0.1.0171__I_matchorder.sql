-- auto gen by root 2016-10-11 20:09:49

CREATE TABLE IF not EXISTS "match_order" (
"id" SERIAL4 NOT NULL,
"api_id" int4,
"match_id" varchar(64) COLLATE "default" NOT NULL,
"type" varchar(32) COLLATE "default",
"league_id" varchar(32) COLLATE "default",
"league_name" varchar(100) COLLATE "default",
"teama_id" varchar(32) COLLATE "default",
"teama_name" varchar(100) COLLATE "default",
"teamb_id" varchar(32) COLLATE "default",
"teamb_name" varchar(100) COLLATE "default",
"match_state" varchar(32) COLLATE "default",
"home_away" varchar(32) COLLATE "default",
"htscore" varchar(100) COLLATE "default",
"ftscore" varchar(100) COLLATE "default",
"result_json" text COLLATE "default",
"match_start_time" timestamp(6),
"match_end_time" timestamp(6),
"create_time" timestamp(6),
"update_time" timestamp(6),
CONSTRAINT "match_order_pkey" PRIMARY KEY ("id"),
CONSTRAINT "u_match_order" UNIQUE ("api_id", "match_id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "match_order" OWNER TO "postgres";

COMMENT ON TABLE "match_order" IS 'api游戏赛事表 ';

COMMENT ON COLUMN "match_order"."id" IS '主键';

COMMENT ON COLUMN "match_order"."api_id" IS 'api表id';

COMMENT ON COLUMN "match_order"."match_id" IS '比赛id';

COMMENT ON COLUMN "match_order"."type" IS '游戏类型，足球，篮球';

COMMENT ON COLUMN "match_order"."league_id" IS '联赛id';

COMMENT ON COLUMN "match_order"."league_name" IS '联赛名称';

COMMENT ON COLUMN "match_order"."teama_id" IS 'A对id';

COMMENT ON COLUMN "match_order"."teama_name" IS 'A对名称';

COMMENT ON COLUMN "match_order"."teamb_id" IS 'A对id';

COMMENT ON COLUMN "match_order"."teamb_name" IS 'A对名称';

COMMENT ON COLUMN "match_order"."match_state" IS 'game.order_state:未结算,已结算,订单取消';

COMMENT ON COLUMN "match_order"."result_json" IS 'result_json';

COMMENT ON COLUMN "match_order"."match_start_time" IS '比赛开始时间';

COMMENT ON COLUMN "match_order"."match_end_time" IS '比赛结束时间';

COMMENT ON COLUMN "match_order"."create_time" IS '入库时间';

COMMENT ON COLUMN "match_order"."update_time" IS '更新时间';



CREATE INDEX "fk_match_order_api_id" ON "match_order" USING btree (api_id);

CREATE INDEX "fk_match_order_api_type_id" ON "match_order" USING btree (type);

CREATE INDEX "fk_match_order_bet_id" ON "match_order" USING btree (match_id);

CREATE INDEX "fk_match_order_game_bet_time" ON "match_order" USING btree (match_start_time);

CREATE INDEX "fk_match_order_payout_time" ON "match_order" USING btree (match_end_time);
