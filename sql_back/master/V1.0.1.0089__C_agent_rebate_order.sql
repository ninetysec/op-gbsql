-- auto gen by cheery 2015-09-21 06:10:50
--创建代理返佣交易订单表
CREATE TABLE IF NOT EXISTS "agent_rebate_order" (
"id" SERIAL4 NOT NULL,
"agent_id" int4,
"transaction_no" varchar(32) COLLATE "default",
"settlement_name" varchar(100) COLLATE "default",
"start_time" timestamp(6),
"end_time" timestamp(6),
"settlement_state" varchar(32) COLLATE "default",
"currency" varchar(20) COLLATE "default",
"rebate_amount" numeric(20,2),
"actual_amount" numeric(20,2),
"create_time" timestamp(6),
"reason_title" varchar(128) COLLATE "default",
"reason_content" varchar(1000) COLLATE "default",
"remark" varchar(1000) COLLATE "default",
CONSTRAINT "agent_rabate_order_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "agent_rebate_order" OWNER TO "postgres";

COMMENT ON TABLE "agent_rebate_order" IS '代理返佣交易订单表';

COMMENT ON COLUMN "agent_rebate_order"."agent_id" IS '代理ID';

COMMENT ON COLUMN "agent_rebate_order"."transaction_no" IS '交易号';

COMMENT ON COLUMN "agent_rebate_order"."settlement_name" IS '结算名称';

COMMENT ON COLUMN "agent_rebate_order"."start_time" IS '返佣开始时间';

COMMENT ON COLUMN "agent_rebate_order"."end_time" IS '返佣结束时间';

COMMENT ON COLUMN "agent_rebate_order"."settlement_state" IS '返佣状态operation.settlement_state(已发放,拒绝发放)';

COMMENT ON COLUMN "agent_rebate_order"."currency" IS '货币common.currency';

COMMENT ON COLUMN "agent_rebate_order"."rebate_amount" IS '返佣金额';

COMMENT ON COLUMN "agent_rebate_order"."actual_amount" IS '实付金额';

COMMENT ON COLUMN "agent_rebate_order"."create_time" IS '返佣创建时间';

COMMENT ON COLUMN "agent_rebate_order"."reason_title" IS '原因标题(拒绝发放时,需要填写原因)';

COMMENT ON COLUMN "agent_rebate_order"."reason_content" IS '原因内容';

COMMENT ON COLUMN "agent_rebate_order"."remark" IS '备注';
