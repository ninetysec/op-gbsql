-- ----------------------------
-- Table structure for settlement_occupy
-- ----------------------------
DROP TABLE IF EXISTS "settlement_occupy";
CREATE TABLE "settlement_occupy" (
"id" serial NOT NULL,
"settlement_name" varchar(100) COLLATE "default",
"start_time" timestamp(6),
"end_time" timestamp(6),
"top_agent_count" int4,
"top_agent_lssuing_count" int4,
"top_agent_reject_count" int4,
"occupy_total" numeric(20,2),
"occupy_actual" numeric(20,2),
"lssuing_state" varchar(32) COLLATE "default",
"last_operate_time" timestamp(6),
"user_id" int4,
"username" varchar(100) COLLATE "default",
"create_time" timestamp(6)
)
WITH (OIDS=FALSE)

;
COMMENT ON TABLE "settlement_occupy" IS '总代占成结算表--Lins';
COMMENT ON COLUMN "settlement_occupy"."id" IS '主键';
COMMENT ON COLUMN "settlement_occupy"."settlement_name" IS '结算名称';
COMMENT ON COLUMN "settlement_occupy"."start_time" IS '占成统计起始时间';
COMMENT ON COLUMN "settlement_occupy"."end_time" IS '占成统计结束时间';
COMMENT ON COLUMN "settlement_occupy"."top_agent_count" IS '参与总代数';
COMMENT ON COLUMN "settlement_occupy"."top_agent_lssuing_count" IS '发放总代数';
COMMENT ON COLUMN "settlement_occupy"."top_agent_reject_count" IS '拒绝发放总代数';
COMMENT ON COLUMN "settlement_occupy"."occupy_total" IS '应付占成金额';
COMMENT ON COLUMN "settlement_occupy"."occupy_actual" IS '实际占成金额';
COMMENT ON COLUMN "settlement_occupy"."lssuing_state" IS '发放状态operation.lssuing_state';
COMMENT ON COLUMN "settlement_occupy"."last_operate_time" IS '最后操作时间';
COMMENT ON COLUMN "settlement_occupy"."user_id" IS '最后操作人ID';
COMMENT ON COLUMN "settlement_occupy"."username" IS '最后操作人';
COMMENT ON COLUMN "settlement_occupy"."create_time" IS '创建时间';

-- ----------------------------
-- Alter Sequences Owned By 
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table settlement_occupy
-- ----------------------------
ALTER TABLE "settlement_occupy" ADD PRIMARY KEY ("id");
