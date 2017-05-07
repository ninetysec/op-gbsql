-- auto gen by cherry 2016-09-17 10:35:43
DROP VIEW IF EXISTS v_player_transaction;
CREATE OR REPLACE VIEW v_player_transaction AS
SELECT pt.id,
    pt.transaction_no,
    pt.create_time,
    pt.transaction_type,
    pt.remark,
    pt.transaction_money,
    pt.balance,
    CASE
        WHEN (((pt.status)::text = 'pending_pay'::text) AND ((pt.create_time + ((pa.effective_minutes || ' minute'::text))::interval) <= now())) THEN 'over_time'::character varying
        ELSE pt.status
    END AS status,
    pt.player_id,
    pt.failure_reason,
    pt.source_id,
    pt.effective_transaction,
    pt.recharge_audit_points,
    pt.relaxing_quota,
    pt.administrative_fee,
    pt.favorable_total_amount,
    pt.favorable_audit_points,
    pt.deduct_favorable,
    pt.is_satisfy_audit,
    pt.is_clear_audit,
    pt.api_money,
    pt.completion_time,
    pt.fund_type,
    pt.transaction_way,
    pt.transaction_data,
    su.username,
    su.user_type,
    agentuser.username AS agentname,
    agentuser.id AS agentid,
    topagentuser.id AS topagentid,
    topagentuser.username AS topagentusername,
    pr.is_first_recharge,
    pr.payer_bankcard,
    pr.recharge_total_amount,
    pr.recharge_amount,
    pr.recharge_address,
    pf.api_id,
    pt.origin
   FROM player_transaction pt
     LEFT JOIN sys_user su ON pt.player_id = su.id
     LEFT JOIN sys_user agentuser ON su.owner_id = agentuser.id
     LEFT JOIN sys_user topagentuser ON agentuser.owner_id = topagentuser.id
     LEFT JOIN player_recharge pr ON pr.id = pt.source_id
     LEFT JOIN pay_account pa ON pa.id = pr.pay_account_id
     LEFT JOIN player_transfer pf ON pf.id = pt.source_id;

COMMENT ON VIEW v_player_transaction IS '玩家交易视图edit by younger';

DROP VIEW IF EXISTS v_occupy_agent;
CREATE OR REPLACE VIEW v_occupy_agent AS
 SELECT oa.agent_id     AS id,
        oa.agent_name,
        ua.owner_id     AS top_agent_id,
        ob.start_time,
        ob.end_time,
        sum(oa.effective_transaction)   AS effective_transaction,
        sum(oa.profit_loss)             AS profit_loss,
        sum(oa.rakeback)                AS rakeback,
        sum(oa.preferential_value)      AS preferential_value,
        sum(oa.refund_fee)              AS refund_fee,
        sum(oa.rebate)                  AS rebate,
        sum(oa.apportion)               AS apportion,
        sum(oa.occupy_total)            AS occupy_total,
        SUM(oa.occupy_actual)           AS occupy_actual
   FROM occupy_bill ob
   LEFT JOIN occupy_agent oa ON ob.id = oa.occupy_bill_id
   LEFT JOIN sys_user ua ON oa.agent_id = ua.id
  WHERE ua.user_type = '23'
  GROUP BY oa.agent_id, oa.agent_name, ua.owner_id, ob.start_time, ob.end_time;

COMMENT ON VIEW v_occupy_agent IS 'Fei - 总代占成统计详细视图';
