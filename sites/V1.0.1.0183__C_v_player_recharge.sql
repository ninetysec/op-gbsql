-- auto gen by admin 2016-06-28 20:01:44
drop view if EXISTS v_player_transaction;

CREATE OR REPLACE VIEW "v_player_transaction" AS

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

    pr.is_first_recharge

   FROM (((((player_transaction pt

     LEFT JOIN sys_user su ON ((pt.player_id = su.id)))

     LEFT JOIN sys_user agentuser ON ((su.owner_id = agentuser.id)))

     LEFT JOIN sys_user topagentuser ON ((agentuser.owner_id = topagentuser.id)))

     LEFT JOIN player_recharge pr ON (((pr.id = pt.source_id) AND ((pt.fund_type)::text = 'online_deposit'::text))))

     LEFT JOIN pay_account pa ON ((pa.id = pr.pay_account_id)));

COMMENT ON VIEW "v_player_transaction" IS '玩家交易视图edit by younger';


delete from notice_tmpl where event_type='CHANGE_PLAYER_DATA' and tmpl_type='manual' and group_code='1441964613850-iuiuty';

update notice_tmpl set event_type='CHANGE_PLAYER_DATA' where event_type='MANUAL_MODIFY_PLAYER' and tmpl_type='auto' and group_code='2b801fbd304e77379393btb9bf1d6c24';