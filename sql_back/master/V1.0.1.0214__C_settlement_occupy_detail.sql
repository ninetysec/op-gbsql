
-- ----------------------------
-- Table structure for settlement_occupy_detail
-- ----------------------------
DROP TABLE IF EXISTS "settlement_occupy_detail";
CREATE TABLE "settlement_occupy_detail" (
"id" serial NOT NULL,
"settlement_occupy_id" int4,
"top_agent_id" int4,
"api_id" int4,
"game_type_parent" varchar(32) COLLATE "default",
"game_type" varchar(32) COLLATE "default",
"occupy_total" numeric(20,2),
"effective_transaction" numeric(20,2),
"profit_loss" numeric(20,2)
)
WITH (OIDS=FALSE)

;
COMMENT ON TABLE "settlement_occupy_detail" IS '总代占成明细表--Lins';
COMMENT ON COLUMN "settlement_occupy_detail"."id" IS '主键';
COMMENT ON COLUMN "settlement_occupy_detail"."settlement_occupy_id" IS '占成结算ID';
COMMENT ON COLUMN "settlement_occupy_detail"."top_agent_id" IS '总代ID';
COMMENT ON COLUMN "settlement_occupy_detail"."api_id" IS 'API表id';
COMMENT ON COLUMN "settlement_occupy_detail"."game_type_parent" IS '一级游戏分类:game.game_type_parent';
COMMENT ON COLUMN "settlement_occupy_detail"."game_type" IS '二级游戏类别:game.game_type';
COMMENT ON COLUMN "settlement_occupy_detail"."occupy_total" IS '占成金额（未扣除分摊费用前的占成金）';
COMMENT ON COLUMN "settlement_occupy_detail"."effective_transaction" IS '有效交易量';
COMMENT ON COLUMN "settlement_occupy_detail"."profit_loss" IS '盈亏';

-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table settlement_occupy_detail
-- ----------------------------
ALTER TABLE "settlement_occupy_detail" ADD PRIMARY KEY ("id");
