-- auto gen by cheery
--创建游戏概况表
CREATE TABLE IF NOT EXISTS "game_survey" (
"id" SERIAL4 NOT NULL,
"center_id"  int4,
"master_id"  int4,
"site_id"  int4,
"statistics_time" timestamp,
"api_id" int4,
"game_type_parent" varchar(32),
"transaction_order" numeric(20,2),
"effective_transaction_volume" numeric(20,2),
"transaction_profit_loss" numeric(20,2),
"transaction_player" int4,
PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "game_survey" OWNER TO "postgres";
COMMENT ON TABLE "game_survey" IS '游戏概况表--suyj';
COMMENT ON COLUMN "game_survey"."id" IS '主键';
COMMENT ON COLUMN "game_survey"."center_id" IS '运营商ID';
COMMENT ON COLUMN "game_survey"."master_id" IS '站长ID';
COMMENT ON COLUMN "game_survey"."site_id" IS '站点ID';
COMMENT ON COLUMN "game_survey"."statistics_time" IS '统计时间,保存到天';
COMMENT ON COLUMN "game_survey"."api_id" IS 'API的ID';
COMMENT ON COLUMN "game_survey"."game_type_parent" IS '游戏分类game.game_type_parent';
COMMENT ON COLUMN "game_survey"."transaction_order" IS '当天交易单量';
COMMENT ON COLUMN "game_survey"."effective_transaction_volume" IS '当天有效交易量';
COMMENT ON COLUMN "game_survey"."transaction_profit_loss" IS '当天交易盈亏';
COMMENT ON COLUMN "game_survey"."transaction_player" IS '当天交易玩家数';