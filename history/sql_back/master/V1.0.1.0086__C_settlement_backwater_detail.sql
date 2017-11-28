-- auto gen by cheery 2015-09-21 05:56:29
--创建返水明细表
CREATE TABLE IF NOT EXISTS "settlement_backwater_detail" (
"id" SERIAL4 NOT NULL,
"settlement_backwater_id" int4,
"player_id" int4,
"api_id" int4,
"game_type_parent" varchar(32) ,
"game_type" varchar(32) ,
"backwater" numeric(20,2),
CONSTRAINT "settlement_backwater_detail_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;
ALTER TABLE "settlement_backwater_detail" OWNER TO "postgres";

COMMENT ON TABLE "settlement_backwater_detail" IS '返水明细表--suyj';
COMMENT ON COLUMN "settlement_backwater_detail"."id" IS '主键';
COMMENT ON COLUMN "settlement_backwater_detail"."settlement_backwater_id" IS '返水结算ID';
COMMENT ON COLUMN "settlement_backwater_detail"."player_id" IS '玩家ID';
COMMENT ON COLUMN "settlement_backwater_detail"."api_id" IS 'API表id';
COMMENT ON COLUMN "settlement_backwater_detail"."game_type_parent" IS '一级游戏分类:game.game_type_parent';
COMMENT ON COLUMN "settlement_backwater_detail"."game_type" IS '二级游戏类别:game.game_type';
COMMENT ON COLUMN "settlement_backwater_detail"."backwater" IS '返水金额';
