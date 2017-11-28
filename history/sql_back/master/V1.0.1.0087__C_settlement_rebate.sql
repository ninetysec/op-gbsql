-- auto gen by cheery 2015-09-21 06:00:44
--创建返佣结算表
CREATE TABLE IF NOT EXISTS "settlement_rebate" (
"id" SERIAL4 NOT NULL,
"settlement_name" varchar(100) ,
"start_time"  timestamp(6),
"end_time"  timestamp(6),
"agent_count" int4,
"agent_lssuing_count" int4,
"agent_reject_count" int4,
"rebate_total" numeric(20,2),
"rebate_actual" numeric(20,2),
"lssuing_state" varchar(32),
"last_operate_time"  timestamp(6),
"user_id"  int4,
"username"  varchar(100) ,
CONSTRAINT "settlement_rebate_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "settlement_rebate" OWNER TO "postgres";
COMMENT ON TABLE "settlement_rebate" IS '返佣结算表--suyj';
COMMENT ON COLUMN "settlement_rebate"."id" IS '主键';
COMMENT ON COLUMN "settlement_rebate"."settlement_name" IS '结算名称';
COMMENT ON COLUMN "settlement_rebate"."start_time" IS '返佣起始时间';
COMMENT ON COLUMN "settlement_rebate"."end_time" IS '返佣结束时间';
COMMENT ON COLUMN "settlement_rebate"."agent_count" IS '参与代理数';
COMMENT ON COLUMN "settlement_rebate"."agent_lssuing_count" IS '发放代理数';
COMMENT ON COLUMN "settlement_rebate"."agent_reject_count" IS '拒绝发放玩家数';
COMMENT ON COLUMN "settlement_rebate"."rebate_total" IS '应付返佣';
COMMENT ON COLUMN "settlement_rebate"."rebate_actual" IS '实际返佣';
COMMENT ON COLUMN "settlement_rebate"."lssuing_state" IS '发放状态operation.lssuing_state';
COMMENT ON COLUMN "settlement_rebate"."last_operate_time" IS '最后操作时间';
COMMENT ON COLUMN "settlement_rebate"."user_id" IS '最后操作人ID';
COMMENT ON COLUMN "settlement_rebate"."username" IS '最后操作人';
