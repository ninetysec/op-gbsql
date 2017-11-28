-- auto gen by cherry 2016-09-23 09:53:39
DROP VIEW IF EXISTS v_player_withdraw ;
ALTER TABLE player_withdraw ALTER COLUMN payee_bankcard TYPE varchar(32);
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
    t1.ip_withdraw,
    t1.ip_dict_code,
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
    t10.username AS lock_person_name,
    t6.id AS agent_id
   FROM ((((((((player_withdraw t1
     LEFT JOIN user_player t4 ON ((t4.id = t1.player_id)))
     LEFT JOIN sys_user t2 ON ((t4.id = t2.id)))
     LEFT JOIN player_transaction p ON ((t1.player_transaction_id = p.id)))
     LEFT JOIN sys_user t3 ON ((t1.check_user_id = t3.id)))
     LEFT JOIN player_rank t5 ON ((t5.id = t4.rank_id)))
     LEFT JOIN sys_user t6 ON ((t6.id = t2.owner_id)))
     LEFT JOIN sys_user t10 ON ((t10.id = t1.lock_person_id)))
     LEFT JOIN sys_user t9 ON ((t9.id = t6.owner_id)));

COMMENT ON VIEW "v_player_withdraw" IS '玩家交易表视图 edit by river重建';