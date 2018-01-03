
-- ----------------------------
-- Table structure for occupy_scheme_detail
-- ----------------------------
DROP TABLE IF EXISTS "occupy_scheme_detail";
CREATE TABLE "occupy_scheme_detail" (
"id" serial4 NOT NULL,
"api_id" int4 NOT NULL,
"game_type" varchar(32) COLLATE "default" NOT NULL,
"occupy_scheme_grads_id" int4 NOT NULL,
"ratio" numeric(20,2) DEFAULT 0
)
WITH (OIDS=FALSE)

;
COMMENT ON TABLE "occupy_scheme_detail" IS '包网占成梯度API比例表--Lins';
COMMENT ON COLUMN "occupy_scheme_detail"."api_id" IS 'api外键';
COMMENT ON COLUMN "occupy_scheme_detail"."game_type" IS '游戏类别:Dicts:     Module:common   Dict_Type:gameType';
COMMENT ON COLUMN "occupy_scheme_detail"."occupy_scheme_grads_id" IS '包网占成梯度表ID，occupy_scheme_grads.id';
COMMENT ON COLUMN "occupy_scheme_detail"."ratio" IS '占成比例';

ALTER TABLE "occupy_scheme_detail" ADD PRIMARY KEY ("id");
