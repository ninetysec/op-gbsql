-- auto gen by cheery 2015-12-03 11:16:30
--修改返佣相关表字段
DROP VIEW IF EXISTS v_rebate_report;
DROP VIEW IF EXISTS v_top_agent_ratio;
DROP VIEW IF EXISTS v_agent_rebate;

select redo_sqls($$
      ALTER TABLE rebate_bill ADD COLUMN period VARCHAR(32);
      ALTER TABLE rebate_bill ADD COLUMN rakeback NUMERIC(20,2);
      ALTER TABLE rebate_agent ADD COLUMN rebate_bill_id INT4;
      ALTER TABLE rebate_agent ADD COLUMN rakeback NUMERIC(20, 2) DEFAULT 0;
      ALTER TABLE rebate_player ADD COLUMN rebate_bill_id INT4;
      ALTER TABLE rebate_player ADD COLUMN rakeback NUMERIC(20, 2) DEFAULT 0;
      ALTER TABLE rebate_api ADD COLUMN rebate_bill_id INT4;
      ALTER TABLE rebate_api ADD COLUMN api_type_id INT4;
      ALTER TABLE agent_rebate_order ADD COLUMN rebate_bill_id INT4;
$$);

ALTER TABLE rebate_bill DROP COLUMN IF EXISTS settlement_name;
ALTER TABLE rebate_bill DROP COLUMN IF EXISTS backwater;
ALTER TABLE rebate_agent DROP COLUMN IF EXISTS settlement_rabate_id;
ALTER TABLE rebate_agent DROP COLUMN IF EXISTS backwater;
ALTER TABLE rebate_player DROP COLUMN IF EXISTS settlement_rabate_id;
ALTER TABLE rebate_player DROP COLUMN IF EXISTS backwater;
ALTER TABLE rebate_api DROP COLUMN IF EXISTS settlement_rebate_id;
ALTER TABLE rebate_api DROP COLUMN IF EXISTS game_type_parent;
ALTER TABLE agent_rebate_order DROP COLUMN IF EXISTS settlement_rebate_id;

COMMENT ON COLUMN rebate_bill.period IS '期数';

COMMENT ON COLUMN rebate_bill.rakeback IS '返水';

COMMENT ON COLUMN rebate_agent.rebate_bill_id IS '返佣账单ID';

COMMENT ON COLUMN rebate_agent.rakeback IS '返水';

COMMENT ON COLUMN rebate_player.rebate_bill_id IS '返佣账单ID';

COMMENT ON COLUMN rebate_player.rakeback IS '返水';

COMMENT ON COLUMN rebate_api.rebate_bill_id IS '返佣账单ID';

COMMENT ON COLUMN rebate_api.api_type_id IS 'api分类';

COMMENT ON COLUMN rebate_api.game_type IS '游戏分类,即api二级分类';

COMMENT ON COLUMN agent_rebate_order.rebate_bill_id IS '返佣账单id';

COMMENT ON VIEW v_player_recharge IS '存款视图--cherry';

CREATE OR REPLACE VIEW v_rebate_report AS
SELECT sra.id,
  sr.id AS rebate_bill_id,
  sra.agent_name,
  su.username,
  sra.effective_player,
  sra.effective_transaction,
  sra.profit_loss,
  sra.deposit_amount,
  sra.withdrawal_amount,
  sra.rakeback,
  sra.refund_fee,
  sra.preferential_value,
  sra.deduct_expenses,
  sra.rebate_total,
  sra.rebate_actual,
  sr.lssuing_state,
  sr.start_time,
  sr.end_time,
  sr.period
FROM rebate_bill sr
LEFT JOIN rebate_agent sra ON sr.id = sra.rebate_bill_id
        LEFT JOIN user_agent ua ON sra.agent_id = ua.id
       LEFT JOIN sys_user su ON ua.parent_id = su.id
WHERE sra.id IS NOT NULL AND sr.end_time >= (now() - '90 days'::interval);

COMMENT ON VIEW v_rebate_report IS '返佣统计视图--fly';

CREATE OR REPLACE VIEW v_top_agent_ratio AS
SELECT sr.id,
  su.username AS agent_name,
  sra.effective_transaction,
  sra.profit_loss,
  sra.deposit_amount,
  sra.withdrawal_amount,
  sra.rakeback,
  sra.preferential_value,
  sra.refund_fee,
  sra.deduct_expenses,
  sra.rebate_total,
  sra.agent_id,
  ua.parent_id AS topagent_id
FROM rebate_agent sra
LEFT JOIN sys_user su ON sra.agent_id = su.id
        LEFT JOIN user_agent ua ON sra.agent_id = ua.id
       LEFT JOIN rebate_bill sr ON sra.rebate_bill_id = sr.id
WHERE ((su.user_type)::text = '23'::text);

COMMENT ON VIEW v_top_agent_ratio IS '总代占成统计视图--fly';

CREATE OR REPLACE VIEW v_agent_rebate AS
  SELECT sb.id,
    su.username,
    srp.effective_transaction,
    srp.profit_loss,
    srp.deposit_amount,
    srp.withdrawal_amount,
    srp.rakeback,
    srp.preferential_value,
    srp.deduct_expenses,
    srp.rebate_total,
    srp.agent_id
  FROM rebate_player srp
  LEFT JOIN sys_user su ON srp.user_id = su.id
         LEFT JOIN rebate_bill sb ON srp.rebate_bill_id = sb.id
  WHERE ((su.user_type)::text = '24'::text);