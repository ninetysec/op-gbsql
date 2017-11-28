
select redo_sqls($$
		DROP TABLE IF EXISTS "settlement_occupy";
		DROP TABLE IF EXISTS "settlement_occupy_detail";
		DROP TABLE IF EXISTS "settlement_occupy_topagent";

		ALTER TABLE operating_report_players RENAME COLUMN game_type_parent TO api_type_id;
		ALTER TABLE operating_report_players ALTER COLUMN api_type_id TYPE int4 USING to_number(api_type_id::TEXT,'99');

		ALTER TABLE operating_report_agent RENAME COLUMN game_type_parent TO api_type_id;
		ALTER TABLE operating_report_agent ALTER COLUMN api_type_id TYPE int4 USING to_number(api_type_id::TEXT,'99');

		ALTER TABLE operating_report_top_agent RENAME COLUMN game_type_parent TO api_type_id;
		ALTER TABLE operating_report_top_agent ALTER COLUMN api_type_id TYPE int4 USING to_number(api_type_id::TEXT,'99');

$$);

-- ----------------------------
-- Table structure for occupy_agent
-- ----------------------------
drop VIEW if EXISTS v_occupy_agent;
DROP TABLE IF EXISTS "occupy_agent";
CREATE TABLE "occupy_agent" (
"id" serial4,
"occupy_bill_id" int4,
"agent_id" int4,
"agent_name" varchar(32) COLLATE "default",
"effective_player" int4,
"effective_transaction" numeric(20,2),
"profit_loss" numeric(20,2),
"deposit_amount" numeric(20,2),
"rebate" numeric(20,2),
"withdrawal_amount" numeric(20,2),
"preferential_value" numeric(20,2),
"occupy_total" numeric(20,2),
"occupy_actual" numeric(20,2),
"remark" varchar(1000) COLLATE "default",
"lssuing_state" varchar(32) COLLATE "default",
"reason_title" varchar(128) COLLATE "default",
"reason_content" varchar(1000) COLLATE "default",
"apportion" numeric(20,2),
"refund_fee" numeric(20,2),
"recommend" numeric(20,2) DEFAULT 0,
"rakeback" numeric(20,2)
)
WITH (OIDS=FALSE)

;
COMMENT ON TABLE "occupy_agent" IS '总代占成-代理贡献-Lins';
COMMENT ON COLUMN "occupy_agent"."id" IS '主键';
COMMENT ON COLUMN "occupy_agent"."occupy_bill_id" IS '返佣结算ID';
COMMENT ON COLUMN "occupy_agent"."agent_id" IS '总代ID';
COMMENT ON COLUMN "occupy_agent"."agent_name" IS '总代账号';
COMMENT ON COLUMN "occupy_agent"."effective_player" IS '有效玩家数';
COMMENT ON COLUMN "occupy_agent"."effective_transaction" IS '有效交易量';
COMMENT ON COLUMN "occupy_agent"."profit_loss" IS '盈亏';
COMMENT ON COLUMN "occupy_agent"."deposit_amount" IS '存款';
COMMENT ON COLUMN "occupy_agent"."rebate" IS '返佣';
COMMENT ON COLUMN "occupy_agent"."withdrawal_amount" IS '取款';
COMMENT ON COLUMN "occupy_agent"."preferential_value" IS '优惠';
COMMENT ON COLUMN "occupy_agent"."occupy_total" IS '应付占成';
COMMENT ON COLUMN "occupy_agent"."occupy_actual" IS '实付占成';
COMMENT ON COLUMN "occupy_agent"."remark" IS '备注';
COMMENT ON COLUMN "occupy_agent"."lssuing_state" IS '发放状态operation.lssuing_state';
COMMENT ON COLUMN "occupy_agent"."reason_title" IS '原因标题';
COMMENT ON COLUMN "occupy_agent"."reason_content" IS '原因内容';
COMMENT ON COLUMN "occupy_agent"."apportion" IS '分摊费用';
COMMENT ON COLUMN "occupy_agent"."refund_fee" IS '返手续费';
COMMENT ON COLUMN "occupy_agent"."rakeback" IS '返水';

-- ----------------------------
-- Table structure for occupy_api
-- ----------------------------
DROP TABLE IF EXISTS "occupy_api";
CREATE TABLE "occupy_api" (
"id" serial4,
"occupy_bill_id" int4,
"player_id" int4,
"api_id" int4,
"game_type" varchar(32) COLLATE "default",
"occupy_total" numeric(20,2),
"effective_transaction" numeric(20,2),
"profit_loss" numeric(20,2),
"api_type_id" int4,
"rakeback" numeric(20,2),
"rebate" numeric(20,2)
)
WITH (OIDS=FALSE)

;
COMMENT ON TABLE "occupy_api" IS '总代占成-API贡献明细表--Lins';
COMMENT ON COLUMN "occupy_api"."id" IS '主键';
COMMENT ON COLUMN "occupy_api"."occupy_bill_id" IS '占成结算ID';
COMMENT ON COLUMN "occupy_api"."player_id" IS '总代ID';
COMMENT ON COLUMN "occupy_api"."api_id" IS 'API表id';
COMMENT ON COLUMN "occupy_api"."game_type" IS '二级游戏类别:game.game_type';
COMMENT ON COLUMN "occupy_api"."occupy_total" IS '占成金额（未扣除分摊费用前的占成金）';
COMMENT ON COLUMN "occupy_api"."effective_transaction" IS '有效交易量';
COMMENT ON COLUMN "occupy_api"."profit_loss" IS '盈亏';
COMMENT ON COLUMN "occupy_api"."api_type_id" IS '总代占成-代理贡献';
COMMENT ON COLUMN "occupy_api"."rakeback" IS '返水';
COMMENT ON COLUMN "occupy_api"."rebate" IS '返佣';

-- ----------------------------
-- Table structure for occupy_bill
-- ----------------------------
DROP VIEW IF EXISTS v_occupy_agent;
DROP TABLE IF EXISTS "occupy_bill";
CREATE TABLE "occupy_bill" (
"id" serial4,
"period" varchar(100) COLLATE "default",
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
"create_time" timestamp(6),
"effective_transaction" numeric(20,2) DEFAULT 0,
"profit_loss" numeric(20,2) DEFAULT 0,
"recommend" numeric(20,2) DEFAULT 0,
"preferential_value" numeric(20,2) DEFAULT 0,
"refund_fee" numeric(20,2) DEFAULT 0,
"rakeback" numeric(20,2) DEFAULT 0,
"apportion" numeric(20,2) DEFAULT 0,
"rebate" numeric(20,2) DEFAULT 0
)
WITH (OIDS=FALSE)

;
COMMENT ON TABLE "occupy_bill" IS '总代占成结算表--Lins';
COMMENT ON COLUMN "occupy_bill"."id" IS '主键';
COMMENT ON COLUMN "occupy_bill"."period" IS '结算名称';
COMMENT ON COLUMN "occupy_bill"."start_time" IS '占成统计起始时间';
COMMENT ON COLUMN "occupy_bill"."end_time" IS '占成统计结束时间';
COMMENT ON COLUMN "occupy_bill"."top_agent_count" IS '参与总代数';
COMMENT ON COLUMN "occupy_bill"."top_agent_lssuing_count" IS '发放总代数';
COMMENT ON COLUMN "occupy_bill"."top_agent_reject_count" IS '拒绝发放总代数';
COMMENT ON COLUMN "occupy_bill"."occupy_total" IS '应付占成金额';
COMMENT ON COLUMN "occupy_bill"."occupy_actual" IS '实际占成金额';
COMMENT ON COLUMN "occupy_bill"."lssuing_state" IS '发放状态operation.lssuing_state';
COMMENT ON COLUMN "occupy_bill"."last_operate_time" IS '最后操作时间';
COMMENT ON COLUMN "occupy_bill"."user_id" IS '最后操作人ID';
COMMENT ON COLUMN "occupy_bill"."username" IS '最后操作人';
COMMENT ON COLUMN "occupy_bill"."create_time" IS '创建时间';
COMMENT ON COLUMN "occupy_bill"."effective_transaction" IS '有效交易量';
COMMENT ON COLUMN "occupy_bill"."profit_loss" IS '盈亏';
COMMENT ON COLUMN "occupy_bill"."recommend" IS '推荐';
COMMENT ON COLUMN "occupy_bill"."preferential_value" IS '优惠';
COMMENT ON COLUMN "occupy_bill"."refund_fee" IS '返手续费';
COMMENT ON COLUMN "occupy_bill"."rakeback" IS '返水';
COMMENT ON COLUMN "occupy_bill"."apportion" IS '费用分摊';
COMMENT ON COLUMN "occupy_bill"."rebate" IS '返佣';

-- ----------------------------
-- Table structure for occupy_player
-- ----------------------------
DROP TABLE IF EXISTS "occupy_player";
CREATE TABLE "occupy_player" (
"id" serial4,
"occupy_bill_id" int4,
"player_id" int4,
"player_name" varchar(32) COLLATE "default",
"effective_transaction" numeric(20,2),
"profit_loss" numeric(20,2),
"deposit_amount" numeric(20,2),
"withdrawal_amount" numeric(20,2),
"preferential_value" numeric(20,2),
"rakeback" numeric(20,2),
"occupy_total" numeric(20,2),
"occupy_actual" numeric(20,2),
"remark" varchar(1000) COLLATE "default",
"lssuing_state" varchar(32) COLLATE "default",
"reason_title" varchar(128) COLLATE "default",
"reason_content" varchar(1000) COLLATE "default",
"apportion" numeric(20,2),
"refund_fee" numeric(20,2),
"recommend" numeric(20,2) DEFAULT 0,
"rebate" numeric(20,2)
)
WITH (OIDS=FALSE)

;
COMMENT ON TABLE "occupy_player" IS '总代占成-玩家贡献表--Lins';
COMMENT ON COLUMN "occupy_player"."id" IS '主键';
COMMENT ON COLUMN "occupy_player"."occupy_bill_id" IS '返佣结算ID';
COMMENT ON COLUMN "occupy_player"."player_id" IS '总代ID';
COMMENT ON COLUMN "occupy_player"."player_name" IS '总代账号';
COMMENT ON COLUMN "occupy_player"."effective_transaction" IS '有效交易量';
COMMENT ON COLUMN "occupy_player"."profit_loss" IS '盈亏';
COMMENT ON COLUMN "occupy_player"."deposit_amount" IS '存款';
COMMENT ON COLUMN "occupy_player"."withdrawal_amount" IS '取款';
COMMENT ON COLUMN "occupy_player"."preferential_value" IS '优惠';
COMMENT ON COLUMN "occupy_player"."rakeback" IS '返水';
COMMENT ON COLUMN "occupy_player"."occupy_total" IS '应付占成';
COMMENT ON COLUMN "occupy_player"."occupy_actual" IS '实付占成';
COMMENT ON COLUMN "occupy_player"."remark" IS '备注';
COMMENT ON COLUMN "occupy_player"."lssuing_state" IS '发放状态operation.lssuing_state';
COMMENT ON COLUMN "occupy_player"."reason_title" IS '原因标题';
COMMENT ON COLUMN "occupy_player"."reason_content" IS '原因内容';
COMMENT ON COLUMN "occupy_player"."apportion" IS '分摊费用';
COMMENT ON COLUMN "occupy_player"."refund_fee" IS '返手续费';
COMMENT ON COLUMN "occupy_player"."rebate" IS '返佣';

-- ----------------------------
-- Table structure for occupy_topagent
-- ----------------------------
DROP view IF EXISTS v_occupy_agent;
DROP TABLE IF EXISTS "occupy_topagent";
CREATE TABLE "occupy_topagent" (
"id" serial4,
"occupy_bill_id" int4,
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
"lssuing_state" varchar(32) COLLATE "default",
"reason_title" varchar(128) COLLATE "default",
"reason_content" varchar(1000) COLLATE "default",
"apportion" numeric(20,2),
"refund_fee" numeric(20,2),
"recommend" numeric(20,2) DEFAULT 0,
"rakeback" numeric(20,2)
)
WITH (OIDS=FALSE)

;
COMMENT ON TABLE "occupy_topagent" IS '总代占成表--Lins';
COMMENT ON COLUMN "occupy_topagent"."id" IS '主键';
COMMENT ON COLUMN "occupy_topagent"."occupy_bill_id" IS '返佣结算ID';
COMMENT ON COLUMN "occupy_topagent"."top_agent_id" IS '总代ID';
COMMENT ON COLUMN "occupy_topagent"."top_agent_name" IS '总代账号';
COMMENT ON COLUMN "occupy_topagent"."effective_agent" IS '有效代理数';
COMMENT ON COLUMN "occupy_topagent"."effective_transaction" IS '有效交易量';
COMMENT ON COLUMN "occupy_topagent"."profit_loss" IS '盈亏';
COMMENT ON COLUMN "occupy_topagent"."deposit_amount" IS '存款';
COMMENT ON COLUMN "occupy_topagent"."rebate" IS '返佣';
COMMENT ON COLUMN "occupy_topagent"."withdrawal_amount" IS '取款';
COMMENT ON COLUMN "occupy_topagent"."preferential_value" IS '优惠';
COMMENT ON COLUMN "occupy_topagent"."deduct_expenses" IS '分摊费用(原扣除费用)';
COMMENT ON COLUMN "occupy_topagent"."occupy_total" IS '应付占成';
COMMENT ON COLUMN "occupy_topagent"."occupy_actual" IS '实付占成';
COMMENT ON COLUMN "occupy_topagent"."remark" IS '备注';
COMMENT ON COLUMN "occupy_topagent"."lssuing_state" IS '发放状态operation.lssuing_state';
COMMENT ON COLUMN "occupy_topagent"."reason_title" IS '原因标题';
COMMENT ON COLUMN "occupy_topagent"."reason_content" IS '原因内容';
COMMENT ON COLUMN "occupy_topagent"."apportion" IS '分摊费用';
COMMENT ON COLUMN "occupy_topagent"."refund_fee" IS '返手续费';
COMMENT ON COLUMN "occupy_topagent"."rakeback" IS '返水';

-- ----------------------------
-- Alter Sequences Owned By
-- ----------------------------

-- ----------------------------
-- Primary Key structure for table occupy_agent
-- ----------------------------
ALTER TABLE "occupy_agent" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table occupy_api
-- ----------------------------
ALTER TABLE "occupy_api" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table occupy_bill
-- ----------------------------
ALTER TABLE "occupy_bill" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table occupy_player
-- ----------------------------
ALTER TABLE "occupy_player" ADD PRIMARY KEY ("id");

-- ----------------------------
-- Primary Key structure for table occupy_topagent
-- ----------------------------
ALTER TABLE "occupy_topagent" ADD PRIMARY KEY ("id");
