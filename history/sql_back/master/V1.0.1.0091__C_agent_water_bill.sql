-- auto gen by cheery 2015-09-21 06:24:36
--创建代理流水账单表
CREATE TABLE IF NOT EXISTS "agent_water_bill" (
"id" SERIAL4 NOT NULL,
"order_id" int4,
"transaction_no" varchar(32) COLLATE "default",
"transaction_finish_time" timestamp(6),
"agent_id" int4,
"transaction_type" varchar(32) COLLATE "default",
"transaction_money" numeric(20,2),
"balance" numeric(20,2),
CONSTRAINT "agent_water_bill_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "agent_water_bill" OWNER TO "postgres";

COMMENT ON TABLE "agent_water_bill" IS '代理流水账单表--suyj';

COMMENT ON COLUMN "agent_water_bill"."id" IS '主键';

COMMENT ON COLUMN "agent_water_bill"."order_id" IS '订单id(取款,返佣分别对应不同的业务表)';

COMMENT ON COLUMN "agent_water_bill"."transaction_no" IS '交易号';

COMMENT ON COLUMN "agent_water_bill"."transaction_finish_time" IS '交易完成时间';

COMMENT ON COLUMN "agent_water_bill"."agent_id" IS '代理ID';

COMMENT ON COLUMN "agent_water_bill"."transaction_type" IS '交易类型common.transaction_type';

COMMENT ON COLUMN "agent_water_bill"."transaction_money" IS '交易金额';

COMMENT ON COLUMN "agent_water_bill"."balance" IS '账号余额';
