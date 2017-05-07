
-- ----------------------------
-- Table structure for settlement_occupy_topagent
-- ----------------------------
DROP TABLE IF EXISTS "settlement_occupy_topagent";
CREATE TABLE "settlement_occupy_topagent" (
"id" serial NOT NULL,
"settlement_occupy_id" int4,
"top_agent_id" int4,
"top_agent_name" varchar(32) COLLATE "default",
"effective_agent" int4,
"effective_transaction" numeric(20,2),
"profit_loss" numeric(20,2),
"deposit_amount" numeric(20,2),
"rebate" numeric(20,2),
"withdrawal_amount" numeric(20,2),
"preferential_value" numeric(20,2),
"deduct_expenses" numeric(20,2),
"occupy_total" numeric(20,2),
"occupy_actual" numeric(20,2),
"remark" varchar(1000) COLLATE "default",
"settlement_state" varchar(32) COLLATE "default",
"reason_title" varchar(128) COLLATE "default",
"reason_content" varchar(1000) COLLATE "default",
"apportion" numeric(20,2),
"refund_fee" numeric(20,2)
)
WITH (OIDS=FALSE)

;
COMMENT ON TABLE "settlement_occupy_topagent" IS '总代占成表--Lins';
COMMENT ON COLUMN "settlement_occupy_topagent"."id" IS '主键';
COMMENT ON COLUMN "settlement_occupy_topagent"."settlement_occupy_id" IS '返佣结算ID';
COMMENT ON COLUMN "settlement_occupy_topagent"."top_agent_id" IS '总代ID';
COMMENT ON COLUMN "settlement_occupy_topagent"."top_agent_name" IS '总代账号';
COMMENT ON COLUMN "settlement_occupy_topagent"."effective_agent" IS '有效代理数';
COMMENT ON COLUMN "settlement_occupy_topagent"."effective_transaction" IS '有效交易量';
COMMENT ON COLUMN "settlement_occupy_topagent"."profit_loss" IS '盈亏';
COMMENT ON COLUMN "settlement_occupy_topagent"."deposit_amount" IS '存款';
COMMENT ON COLUMN "settlement_occupy_topagent"."rebate" IS '返佣';
COMMENT ON COLUMN "settlement_occupy_topagent"."withdrawal_amount" IS '取款';
COMMENT ON COLUMN "settlement_occupy_topagent"."preferential_value" IS '优惠';
COMMENT ON COLUMN "settlement_occupy_topagent"."deduct_expenses" IS '分摊费用(原扣除费用)';
COMMENT ON COLUMN "settlement_occupy_topagent"."occupy_total" IS '应付占成';
COMMENT ON COLUMN "settlement_occupy_topagent"."occupy_actual" IS '实付占成';
COMMENT ON COLUMN "settlement_occupy_topagent"."remark" IS '备注';
COMMENT ON COLUMN "settlement_occupy_topagent"."settlement_state" IS '结算状态operation.settlement_state';
COMMENT ON COLUMN "settlement_occupy_topagent"."reason_title" IS '原因标题';
COMMENT ON COLUMN "settlement_occupy_topagent"."reason_content" IS '原因内容';
COMMENT ON COLUMN "settlement_occupy_topagent"."apportion" IS '分摊费用';
COMMENT ON COLUMN "settlement_occupy_topagent"."refund_fee" IS '返手续费';

-- ----------------------------
-- Alter Sequences Owned By
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table settlement_occupy_topagent
-- ----------------------------
ALTER TABLE "settlement_occupy_topagent" ADD PRIMARY KEY ("id");
