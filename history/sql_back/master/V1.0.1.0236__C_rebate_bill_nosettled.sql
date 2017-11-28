-- auto gen by cheery 2015-11-27 11:50:21
--修改返佣相关表表名
DROP VIEW if EXISTS v_agent_rebate;
DROP VIEW if EXISTS v_top_agent_ratio;
DROP VIEW if EXISTS v_rebate_report;

SELECT redo_sqls($$
  alter table settlement_rebate_player add COLUMN agent_id INTEGER; -- 代理ID
$$);

ALTER TABLE IF EXISTS settlement_rebate rename to rebate_bill;
ALTER TABLE IF EXISTS settlement_rebate_agent rename to rebate_agent;
ALTER TABLE IF EXISTS settlement_rebate_player rename to rebate_player;
ALTER TABLE IF EXISTS settlement_rebate_detail rename to rebate_api;

ALTER SEQUENCE IF EXISTS settlement_rebate_id_seq rename to rebate_bill_id_seq;
ALTER SEQUENCE IF EXISTS settlement_rebate_agent_id_seq rename to rebate_agent_id_seq;
ALTER SEQUENCE IF EXISTS settlement_rebate_player_id_seq rename to rebate_player_id_seq;
ALTER SEQUENCE IF EXISTS settlement_rebate_detail_id_seq rename to rebate_api_id_seq;

CREATE OR REPLACE VIEW v_agent_rebate AS
  SELECT sb.id,
    su.username,
    srp.effective_transaction,
    srp.profit_loss,
    srp.deposit_amount,
    srp.withdrawal_amount,
    srp.backwater,
    srp.preferential_value,
    srp.deduct_expenses,
    srp.rebate_total,
    srp.agent_id
  FROM rebate_player srp
    LEFT JOIN sys_user su ON srp.user_id = su.id
    LEFT JOIN rebate_bill sb ON srp.settlement_rabate_id = sb.id
  WHERE su.user_type::text = '24'::text;
ALTER TABLE v_agent_rebate OWNER TO postgres;
COMMENT ON VIEW v_agent_rebate IS '代理返佣统计详细视图';

CREATE OR REPLACE VIEW v_top_agent_ratio AS
  SELECT sr.id,
    su.username AS agent_name,
    sra.effective_transaction,
    sra.profit_loss,
    sra.deposit_amount,
    sra.withdrawal_amount,
    sra.backwater,
    sra.preferential_value,
    sra.refund_fee,
    sra.deduct_expenses,
    sra.rebate_total,
    sra.agent_id,
    ua.parent_id AS topagent_id
  FROM rebate_agent sra
    LEFT JOIN sys_user su ON sra.agent_id = su.id
    LEFT JOIN user_agent ua ON sra.agent_id = ua.id
    LEFT JOIN rebate_bill sr ON sra.settlement_rabate_id = sr.id
  WHERE su.user_type::text = '23'::text;

ALTER TABLE v_top_agent_ratio OWNER TO postgres;

COMMENT ON VIEW v_top_agent_ratio IS '总代占成统计详细视图';

CREATE OR REPLACE VIEW v_rebate_report AS
  SELECT sra.id,
    sr.id AS rebate_id,
    sra.agent_name,
    su.username,
    sra.effective_player,
    sra.effective_transaction,
    sra.profit_loss,
    sra.deposit_amount,
    sra.withdrawal_amount,
    sra.backwater,
    sra.refund_fee,
    sra.preferential_value,
    sra.deduct_expenses,
    sra.rebate_total,
    sra.rebate_actual,
    sr.lssuing_state,
    sr.start_time,
    sr.end_time,
    sr.settlement_name
  FROM rebate_bill sr
    LEFT JOIN rebate_agent sra ON sr.id = sra.settlement_rabate_id
    LEFT JOIN user_agent ua ON sra.agent_id = ua.id
    LEFT JOIN sys_user su ON ua.parent_id = su.id
  WHERE sra.id IS NOT NULL AND sr.end_time >= (now() - '90 days'::interval);

ALTER TABLE v_rebate_report
OWNER TO postgres;
COMMENT ON VIEW v_rebate_report
IS '返佣统计详细视图';

--创建返佣未出账单表
CREATE TABLE IF NOT EXISTS rebate_bill_nosettled(
  id SERIAL4 NOT NULL,
  start_time TIMESTAMP(6),
  end_time TIMESTAMP(6),
  rebate_total NUMERIC(20,2),
  create_time TIMESTAMP(6),
  CONSTRAINT "rebate_bill_nosettled_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;
ALTER TABLE "rebate_bill_nosettled" OWNER TO "postgres";

COMMENT ON TABLE rebate_bill_nosettled IS '返佣未出账单表--susu';

COMMENT ON COLUMN rebate_bill_nosettled.id IS '主键';

COMMENT ON COLUMN rebate_bill_nosettled.start_time IS '预结算起始时间';

COMMENT ON COLUMN rebate_bill_nosettled.end_time IS '预结算结束时间';

COMMENT ON COLUMN rebate_bill_nosettled.rebate_total IS '应付返佣';

COMMENT ON COLUMN rebate_bill_nosettled.create_time IS '统计时间';


--创建代理未出账返佣表
CREATE TABLE IF NOT EXISTS rebate_agent_nosettled(
  id SERIAL4 NOT NULL ,
  rebate_bill_nosettled_id INT4,
  agent_id INT4,
  agent_name VARCHAR(100),
  effective_player INT4,
  effective_transaction NUMERIC(20,2),
  profit_loss NUMERIC(20,2),
  deposit_amount NUMERIC(20,2),
  rakeback NUMERIC(20,2),
  withdrawal_amount NUMERIC(20,2),
  preferential_value NUMERIC(20,2),
  deduct_expenses NUMERIC(20,2),
  rebate_total NUMERIC(20,2),
  apportion NUMERIC(20,2),
  refund_fee NUMERIC(20,2),
  CONSTRAINT "rebate_agent_nosettled_id_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;
ALTER TABLE "rebate_agent_nosettled" OWNER TO "postgres";

COMMENT ON TABLE rebate_agent_nosettled IS '代理未出账返佣表--susu';

COMMENT ON COLUMN rebate_agent_nosettled.id IS '主键';

COMMENT ON COLUMN rebate_agent_nosettled.rebate_bill_nosettled_id IS '账单ID';

COMMENT ON COLUMN rebate_agent_nosettled.agent_id IS '代理ID';

COMMENT ON COLUMN rebate_agent_nosettled.agent_name IS '代理账号';

COMMENT ON COLUMN rebate_agent_nosettled.effective_player IS '有效玩家';

COMMENT ON COLUMN rebate_agent_nosettled.effective_transaction IS '有效交易量';

COMMENT ON COLUMN rebate_agent_nosettled.profit_loss IS '盈亏';

COMMENT ON COLUMN rebate_agent_nosettled.deposit_amount IS '存款';

COMMENT ON COLUMN rebate_agent_nosettled.rakeback IS '返水';

COMMENT ON COLUMN rebate_agent_nosettled.withdrawal_amount IS '取款';

COMMENT ON COLUMN rebate_agent_nosettled.preferential_value IS '优惠';

COMMENT ON COLUMN rebate_agent_nosettled.deduct_expenses IS '扣除费用';

COMMENT ON COLUMN rebate_agent_nosettled.rebate_total IS '应付佣金';

COMMENT ON COLUMN rebate_agent_nosettled.apportion IS '分摊费用';

COMMENT ON COLUMN rebate_agent_nosettled.refund_fee IS '返手续费';

--创建玩家未出返佣表
CREATE TABLE IF NOT EXISTS rebate_player_nosettled(
  id SERIAL4 NOT NULL,
  rebate_bill_nosettled_id INT4,
  effective_transaction NUMERIC(20,2),
  player_id INT4,
  profit_loss NUMERIC(20,2),
  deposit_amount NUMERIC(20,2),
  withdrawal_amount NUMERIC(20,2),
  rakeback NUMERIC(20,2),
  preferential_value NUMERIC(20,2),
  deduct_expenses NUMERIC(20,2),
  rebate_total NUMERIC(20,2),
  CONSTRAINT "rebate_player_nosettled_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;
ALTER TABLE "rebate_player_nosettled" OWNER TO "postgres";

COMMENT ON TABLE rebate_player_nosettled IS '玩家未出返佣表--susu';

COMMENT ON  COLUMN rebate_player_nosettled.id IS '主键';

COMMENT ON COLUMN rebate_player_nosettled.rebate_bill_nosettled_id IS '账单ID';

COMMENT ON COLUMN rebate_player_nosettled.effective_transaction IS '有效交易量';

COMMENT ON COLUMN rebate_player_nosettled.player_id IS '玩家id';

COMMENT ON COLUMN rebate_player_nosettled.profit_loss IS '总交易盈亏';

COMMENT ON COLUMN rebate_player_nosettled.deposit_amount IS '存款';

COMMENT ON COLUMN rebate_player_nosettled.withdrawal_amount IS '取款';

COMMENT ON COLUMN rebate_player_nosettled.rakeback IS '返水';

COMMENT ON COLUMN rebate_player_nosettled.preferential_value IS '优惠';

COMMENT ON COLUMN rebate_player_nosettled.deduct_expenses IS '分摊总费用';

COMMENT ON COLUMN rebate_player_nosettled.rebate_total IS '产生佣金';

--创建api未出返佣表
CREATE TABLE IF NOT EXISTS rebate_api_nosettled(
  id SERIAL4 NOT NULL ,
  rebate_bill_nosettled_id INT4,
  player_id INT4,
  api_id INT4,
  api_type_id INT4,
  game_type VARCHAR(32),
  rebate_total NUMERIC(20,2),
  CONSTRAINT "rebate_api_nosettled_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;
ALTER TABLE "rebate_api_nosettled" OWNER TO "postgres";

COMMENT ON TABLE rebate_api_nosettled IS 'api未出返佣表--susu';

COMMENT ON COLUMN rebate_api_nosettled.id IS '主键';

COMMENT ON COLUMN rebate_api_nosettled.rebate_bill_nosettled_id IS '账单ID';

COMMENT ON COLUMN rebate_api_nosettled.player_id IS '玩家ID';

COMMENT ON COLUMN rebate_api_nosettled.api_id IS 'API表id';

COMMENT ON COLUMN rebate_api_nosettled.api_type_id IS 'api分类';

COMMENT ON COLUMN rebate_api_nosettled.game_type IS '游戏分类,即api二级分类';

COMMENT ON COLUMN rebate_api_nosettled.rebate_total IS '返佣金额（未扣除分摊费用前的佣金）';
