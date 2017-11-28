-- auto gen by cherry 2016-11-12 10:19:36
DROP VIEW IF EXISTS v_player_api_transaction;
CREATE OR REPLACE VIEW "v_player_api_transaction" AS
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
    pt.origin,
    pt.rank_id
   FROM ((((((player_transaction pt
     LEFT JOIN sys_user su ON ((pt.player_id = su.id)))
     LEFT JOIN sys_user agentuser ON ((su.owner_id = agentuser.id)))
     LEFT JOIN sys_user topagentuser ON ((agentuser.owner_id = topagentuser.id)))
     LEFT JOIN player_recharge pr ON ((pr.id = pt.source_id)))
     LEFT JOIN pay_account pa ON ((pa.id = pr.pay_account_id)))
     LEFT JOIN player_transfer pf ON ((pf.id = pt.source_id)));

COMMENT on view v_player_api_transaction is 'api转帐视图';

ALTER TABLE player_game_order DROP COLUMN IF EXISTS bet_type;