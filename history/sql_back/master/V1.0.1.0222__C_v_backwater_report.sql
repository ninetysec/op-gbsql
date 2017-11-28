-- auto gen by cheery 2015-11-24 02:03:46
/* -------- 返水统计详细视图 -------- */
DROP VIEW IF EXISTS v_backwater_report;
CREATE OR REPLACE VIEW v_backwater_report AS
  SELECT
    sb."id",
    bp.player_id,
    bp.username  player_name,
    bp.backwater_total,
    bp.backwater_actual,
    bp.agent_id,
    bp.top_agent_id,
    sb.lssuing_state,
    sb.start_time,
    sb.end_time,
    sb.settlement_name,
    su1.username agent_name,
    su2.username topagent_name
  FROM settlement_backwater_player bp
    LEFT JOIN settlement_backwater sb ON bp.settlement_backwater_id = sb."id"
    LEFT JOIN sys_user su1 ON bp.agent_id = su1."id"
    LEFT JOIN sys_user su2 ON bp.top_agent_id = su2."id"
  WHERE sb.end_time >= now() - INTERVAL '90 day';

ALTER TABLE v_backwater_report OWNER TO postgres;
COMMENT ON VIEW v_backwater_report IS '返水统计详细视图--fly';

/* -------- 返佣统计详细视图 -------- */
DROP VIEW IF EXISTS v_report_settlement_rebate;
DROP VIEW IF EXISTS v_report_settlement_rebate_detail;

DROP VIEW IF EXISTS v_rebate_report;
CREATE OR REPLACE VIEW v_rebate_report AS
  SELECT
    sra."id",
    sr."id" rebate_id,
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
  FROM
    settlement_rebate sr
    LEFT JOIN settlement_rebate_agent sra
      ON sr."id" = sra.settlement_rabate_id
    LEFT JOIN user_agent ua
      ON sra.agent_id = ua."id"
    LEFT JOIN sys_user su
      ON ua.parent_id = su."id"
  WHERE sra."id" IS NOT NULL
        AND sr.end_time >= now()-interval '90 day';

ALTER TABLE v_rebate_report OWNER TO postgres;
COMMENT ON VIEW v_rebate_report IS '返佣统计详细视图--fly';