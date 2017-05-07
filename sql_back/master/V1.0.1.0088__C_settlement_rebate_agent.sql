-- auto gen by cheery 2015-09-21 06:06:08
--代理返佣结算表
CREATE TABLE IF NOT EXISTS "settlement_rebate_agent" (
"id" SERIAL4 NOT NULL,
"settlement_rabate_id" int4,
"agent_id"  int4,
"agent_name"  varchar(32),
"effective_player" int4,
"effective_transaction" numeric(20,2),
"profit_loss" numeric(20,2),
"deposit_amount" numeric(20,2),
"backwater" numeric(20,2),
"withdrawal_amount" numeric(20,2),
"preferential_value" numeric(20,2),
"deduct_expenses" numeric(20,2),
"rebate_total" numeric(20,2),
"rebate_actual" numeric(20,2),
"remark" varchar(1000),
"settlement_state" varchar(32),
"reason_title" varchar(128),
"reason_content" varchar(1000),
CONSTRAINT "settlement_rebate_agent_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;
ALTER TABLE "settlement_rebate_agent" OWNER TO "postgres";

COMMENT ON TABLE "settlement_rebate_agent" IS '代理返佣表--suyj';
COMMENT ON COLUMN "settlement_rebate_agent"."id" IS '主键';
COMMENT ON COLUMN "settlement_rebate_agent"."settlement_rabate_id" IS '返佣结算ID';
COMMENT ON COLUMN "settlement_rebate_agent"."agent_id" IS '代理ID';
COMMENT ON COLUMN "settlement_rebate_agent"."agent_name" IS '代理账号';
COMMENT ON COLUMN "settlement_rebate_agent"."effective_player" IS '有效玩家';
COMMENT ON COLUMN "settlement_rebate_agent"."effective_transaction" IS '有效交易量';
COMMENT ON COLUMN "settlement_rebate_agent"."profit_loss" IS '盈亏';
COMMENT ON COLUMN "settlement_rebate_agent"."deposit_amount" IS '存款';
COMMENT ON COLUMN "settlement_rebate_agent"."backwater" IS '返水';
COMMENT ON COLUMN "settlement_rebate_agent"."withdrawal_amount" IS '取款';
COMMENT ON COLUMN "settlement_rebate_agent"."preferential_value" IS '优惠';
COMMENT ON COLUMN "settlement_rebate_agent"."deduct_expenses" IS '扣除费用';
COMMENT ON COLUMN "settlement_rebate_agent"."rebate_total" IS '应付佣金';
COMMENT ON COLUMN "settlement_rebate_agent"."rebate_actual" IS '实付佣金';
COMMENT ON COLUMN "settlement_rebate_agent"."remark" IS '备注';
COMMENT ON COLUMN "settlement_rebate_agent"."settlement_state" IS '结算状态operation.settlement_state';
COMMENT ON COLUMN "settlement_rebate_agent"."reason_title" IS '原因标题';
COMMENT ON COLUMN "settlement_rebate_agent"."reason_content" IS '原因内容';
