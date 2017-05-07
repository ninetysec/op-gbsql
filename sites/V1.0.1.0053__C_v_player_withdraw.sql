-- auto gen by cherry 2016-03-11 19:32:21
drop view if exists v_player_withdraw;
drop view if exists  v_favorable_order;
drop view if exists v_player_transaction;

ALTER TABLE "player_withdraw" ALTER COLUMN "reason_content" TYPE varchar(1000) COLLATE "default";

ALTER TABLE "player_transaction" ALTER COLUMN "failure_reason" TYPE varchar(1000) COLLATE "default";

CREATE OR REPLACE VIEW "v_player_withdraw" AS
 SELECT t1.id,
    t1.player_id,
    t1.player_transaction_id,
    t1.transaction_no,
    t1.current_account_amount,
    t1.current_return_zero_amount,
    t1.current_backflush_amount,
    t1.withdraw_monetary,
    t1.withdraw_amount,
    t1.withdraw_remark,
    t1.deduct_favorable,
    t1.counter_fee,
    t1.administrative_fee,
    t1.is_deduct_audit,
    t1.deduct_audit_recharge_amount,
    t1.deduct_audit_recharge_index,
    t1.deduct_audit_favorable_amount,
    t1.deduct_audit_favorable_index,
    t1.withdraw_type,
    t1.create_time,
    t1.payee_bank,
    t1.payee_bankcard,
    t1.payee_name,
    t1.withdraw_status,
    t1.check_status,
    t1.check_time,
    t1.check_user_id,
    t1.check_remark,
    t1.is_clear_audit,
    t1.is_warn,
    t1.check_closing_time,
    t1.withdraw_type_parent,
    t1.withdraw_actual_amount,
    t1.play_money_time,
    t1.play_money_user,
    t1.reason_content,
    t1.artificial_reason_content,
    t1.is_lock,
    t1.lock_person_id,
    t1.is_satisfy_audit,
    t1.artificial_reason_title,
    t1.reason_title,
    t4.withdraw_count AS success_count,
    (date_part('epoch'::text, ((t1.check_closing_time)::timestamp with time zone - now())) / (60)::double precision) AS closing_time,
    p.remark,
    t2.username,
    t3.username AS check_user_name,
    t4.rank_id,
    t2.region,
    t2.nation,
    t2.country,
    t2.city,
    t2.real_name,
    t2.create_time AS register_time,
    t2.status,
    t5.risk_marker,
    t5.rank_name,
    t6.username AS agent_name,
    t9.username AS general_agent_name,
    t10.username AS lock_person_name
   FROM ((((((((player_withdraw t1
     LEFT JOIN user_player t4 ON ((t4.id = t1.player_id)))
     LEFT JOIN sys_user t2 ON ((t4.id = t2.id)))
     LEFT JOIN player_transaction p ON ((t1.player_transaction_id = p.id)))
     LEFT JOIN sys_user t3 ON ((t1.check_user_id = t3.id)))
     LEFT JOIN player_rank t5 ON ((t5.id = t4.rank_id)))
     LEFT JOIN sys_user t6 ON ((t6.id = t2.owner_id)))
     LEFT JOIN sys_user t10 ON ((t10.id = t1.lock_person_id)))
     LEFT JOIN sys_user t9 ON ((t9.id = t6.owner_id)));

COMMENT ON VIEW "v_player_withdraw" IS '玩家取款视图 edit by river重建';



CREATE OR REPLACE VIEW "v_favorable_order" AS
 SELECT t1.id,
    t1.apply_time AS create_time,
        CASE
            WHEN ((t2.preferential_form)::text = 'percentage_handsel'::text) THEN (t2.preferential_value * t3.recharge_amount)
            WHEN ((t2.preferential_form)::text = 'regular_handsel'::text) THEN t2.preferential_value
            ELSE NULL::numeric
        END AS favorable,
    NULL::character varying AS transaction_no,
    NULL::character varying AS status,
    NULL::character varying AS favorable_source,
    t3.transaction_no AS recharge_transaction_no
   FROM ((activity_player_apply t1
     LEFT JOIN activity_way_relation t2 ON ((t1.activity_message_id = t2.activity_message_id)))
     LEFT JOIN player_recharge t3 ON ((t1.player_recharge_id = t3.id)))
  WHERE ((t1.check_state)::text = '1'::text)
UNION ALL
 SELECT t1.id,
    t2.create_time,
    t1.favorable,
    t1.transaction_no,
    t2.status,
    t1.favorable_source,
    t3.transaction_no AS recharge_transaction_no
   FROM ((player_favorable t1
     LEFT JOIN player_transaction t2 ON ((t2.id = t1.player_transaction_id)))
     LEFT JOIN player_recharge t3 ON ((t1.player_recharge_id = t3.id)));

ALTER TABLE "v_favorable_order" OWNER TO "postgres";

COMMENT ON VIEW "v_favorable_order" IS '查看所有优惠订单--cherry';

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
    topagentuser.username AS topagentusername
   FROM (((((player_transaction pt
     LEFT JOIN sys_user su ON ((pt.player_id = su.id)))
     LEFT JOIN sys_user agentuser ON ((su.owner_id = agentuser.id)))
     LEFT JOIN sys_user topagentuser ON ((agentuser.owner_id = topagentuser.id)))
     LEFT JOIN player_recharge pr ON (((pr.id = pt.source_id) AND ((pt.fund_type)::text = 'online_deposit'::text))))
     LEFT JOIN pay_account pa ON ((pa.id = pr.pay_account_id)));

COMMENT ON VIEW "v_player_withdraw" IS '玩家交易表视图 edit by river重建';