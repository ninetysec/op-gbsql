-- auto gen by longer 2015-11-24 15:16:23

--以下脚本是此脚本遗漏的,因此再新建脚本重新执行一次
--V1.0.1.0131__U_sys_resource_lorne()

-- View: v_agent_fund_record

-- DROP VIEW v_agent_fund_record;

CREATE OR REPLACE VIEW v_agent_fund_record AS
  SELECT a.id,
    a.transaction_no,
    a.agent_id,
    a.create_time,
    b.transaction_money,
    b.balance,
    CASE a.settlement_state
    WHEN 'pending_lssuing'::text THEN '1'::text
    WHEN 'lssuing'::text THEN '2'::text
    WHEN 'reject_lssuing'::text THEN '4'::text
    ELSE 'ONO'::text
    END AS status,
    1 AS type,
    a.settlement_name AS periods,
    a.start_time
  FROM agent_rebate_order a
    LEFT JOIN agent_water_bill b ON a.id = b.order_id
  UNION
  SELECT a.id,
    a.transaction_no,
    a.agent_id,
    a.create_time,
    b.transaction_money,
    b.balance,
    a.transaction_status AS status,
    2 AS type,
    ''::character varying AS periods,
    now() AS start_time
  FROM agent_withdraw_order a
    LEFT JOIN agent_water_bill b ON a.id = b.order_id;

ALTER TABLE v_agent_fund_record
OWNER TO postgres;
COMMENT ON VIEW v_agent_fund_record
IS '代理资金账户流水--lorne';


-- Table: settlement_rebate_player

-- DROP TABLE settlement_rebate_player;
CREATE TABLE IF NOT EXISTS settlement_rebate_player
(
  id serial NOT NULL,
  settlement_rabate_id integer, -- 返佣结算ID
  effective_transaction numeric(20,2) DEFAULT 0, -- 有效交易量
  user_id integer, -- 玩家id
  profit_loss numeric(20,2) DEFAULT 0, -- 总交易盈亏
  deposit_amount numeric(20,2) DEFAULT 0, -- 存款
  withdrawal_amount numeric(20,2) DEFAULT 0, -- 取款
  backwater numeric(20,2) DEFAULT 0, -- 返水
  preferential_value numeric(20,2) DEFAULT 0, -- 优惠
  deduct_expenses numeric(20,2) DEFAULT 0, -- 分摊总费用
  rebate_total numeric(20,2) DEFAULT 0, -- 产生佣金
  CONSTRAINT settlement_rebate_player_pkey PRIMARY KEY (id)
)
WITH (
OIDS=FALSE
);
ALTER TABLE settlement_rebate_player
OWNER TO postgres;
COMMENT ON TABLE settlement_rebate_player
IS '玩家返佣明细表--lorne';
COMMENT ON COLUMN settlement_rebate_player.settlement_rabate_id IS '返佣结算ID';
COMMENT ON COLUMN settlement_rebate_player.effective_transaction IS '有效交易量';
COMMENT ON COLUMN settlement_rebate_player.user_id IS '玩家id';
COMMENT ON COLUMN settlement_rebate_player.profit_loss IS '总交易盈亏';
COMMENT ON COLUMN settlement_rebate_player.deposit_amount IS '存款';
COMMENT ON COLUMN settlement_rebate_player.withdrawal_amount IS '取款';
COMMENT ON COLUMN settlement_rebate_player.backwater IS '返水';
COMMENT ON COLUMN settlement_rebate_player.preferential_value IS '优惠';
COMMENT ON COLUMN settlement_rebate_player.deduct_expenses IS '分摊总费用';
COMMENT ON COLUMN settlement_rebate_player.rebate_total IS '产生佣金';