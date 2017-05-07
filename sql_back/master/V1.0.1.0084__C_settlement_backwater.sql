-- auto gen by cheery 2015-09-21 05:37:45
--创建返水结算表
CREATE TABLE IF NOT EXISTS "settlement_backwater" (
"id" SERIAL4 NOT NULL,
"settlement_name" varchar(100) ,
"start_time"  timestamp(6),
"end_time"  timestamp(6),
"player_count" int4,
"player_lssuing_count" int4,
"player_reject_count" int4,
"backwater_total" numeric(20,2),
"backwater_actual" numeric(20,2),
"lssuing_state" varchar(32),
"last_operate_time"  timestamp(6),
"user_id"  int4,
"username"  varchar(100) ,
CONSTRAINT "settlement_backwater_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;
ALTER TABLE "settlement_backwater" OWNER TO "postgres";

COMMENT ON TABLE "settlement_backwater" IS '返水结算表--suyj';
COMMENT ON COLUMN "settlement_backwater"."id" IS '主键';
COMMENT ON COLUMN "settlement_backwater"."settlement_name" IS '结算名称';
COMMENT ON COLUMN "settlement_backwater"."start_time" IS '返水起始时间';
COMMENT ON COLUMN "settlement_backwater"."end_time" IS '返水结束时间';
COMMENT ON COLUMN "settlement_backwater"."player_count" IS '参与玩家数';
COMMENT ON COLUMN "settlement_backwater"."player_lssuing_count" IS '发放玩家数';
COMMENT ON COLUMN "settlement_backwater"."player_reject_count" IS '拒绝发放玩家数';
COMMENT ON COLUMN "settlement_backwater"."backwater_total" IS '应付返水';
COMMENT ON COLUMN "settlement_backwater"."backwater_actual" IS '实际返水';
COMMENT ON COLUMN "settlement_backwater"."lssuing_state" IS '发放状态operation.lssuing_state';
COMMENT ON COLUMN "settlement_backwater"."last_operate_time" IS '最后操作时间';
COMMENT ON COLUMN "settlement_backwater"."user_id" IS '最后操作人ID';
COMMENT ON COLUMN "settlement_backwater"."username" IS '最后操作人';