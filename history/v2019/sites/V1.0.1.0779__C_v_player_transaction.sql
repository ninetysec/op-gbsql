-- auto gen by linsen 2018-04-24 12:04:05
-- 修改视图代理线信息从player_transaction表获取 by linsen
DROP VIEW IF EXISTS v_player_transaction;
CREATE OR REPLACE VIEW  "v_player_transaction" AS
 SELECT pt.id,
    pt.transaction_no,
    pt.create_time,
    pt.transaction_type,
    pt.remark,
    pt.transaction_money,
    pt.balance,
    pt.status,
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
    pt.agent_username AS agentname,
    pt.agent_id AS agentid,
    pt.topagent_id AS topagentid,
    pt.topagent_username AS topagentusername,
    pr.is_first_recharge,
    pr.payer_bankcard,
    pr.recharge_total_amount,
    pr.recharge_amount,
    pr.recharge_address,
    pf.api_id,
    pt.origin,
    pt.rank_id
   FROM (((player_transaction pt
     LEFT JOIN sys_user su ON ((pt.player_id = su.id)))
     LEFT JOIN player_recharge pr ON (((pr.transaction_no)::text = (pt.transaction_no)::text)))
     LEFT JOIN player_transfer pf ON ((pf.id = pt.source_id)));


COMMENT ON VIEW "v_player_transaction" IS '资金记录视图 By steffan';