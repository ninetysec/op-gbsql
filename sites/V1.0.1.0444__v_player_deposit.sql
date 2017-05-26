-- auto gen by tony 2017-05-26 01:49:06
update player_withdraw set rank_id=user_player.rank_id from user_player where player_withdraw.rank_id IS NULL and player_withdraw.player_id=user_player."id";

CREATE OR REPLACE VIEW v_player_withdraw AS
 SELECT pw.id,
        pw.player_id,
        pw.player_transaction_id,
        pw.transaction_no,
        pw.current_account_amount,
        pw.current_return_zero_amount,
        pw.current_backflush_amount,
        pw.withdraw_monetary,
        pw.withdraw_amount,
        pw.withdraw_remark,
        pw.deduct_favorable,
        pw.counter_fee,
        pw.administrative_fee,
        pw.is_deduct_audit,
        pw.deduct_audit_recharge_amount,
        pw.deduct_audit_recharge_index,
        pw.deduct_audit_favorable_amount,
        pw.deduct_audit_favorable_index,
        pw.withdraw_type,
        pw.create_time,
        pw.payee_bank,
        pw.payee_bankcard,
        pw.payee_name,
        pw.withdraw_status,
        pw.check_status,
        pw.check_time,
        pw.check_user_id,
        pw.check_remark,
        pw.is_clear_audit,
        pw.is_warn,
        pw.check_closing_time,
        pw.withdraw_type_parent,
        pw.withdraw_actual_amount,
        pw.play_money_time,
        pw.play_money_user,
        pw.reason_content,
        pw.artificial_reason_content,
        pw.is_lock,
        pw.lock_person_id,
        pw.is_satisfy_audit,
        pw.artificial_reason_title,
        pw.reason_title,
        pw.ip_withdraw,
        pw.ip_dict_code,
        up.withdraw_count AS success_count,
        (date_part('epoch'::text, ((pw.check_closing_time)::timestamp with time zone - now())) / (60)::double precision) AS closing_time,
        pt.remark,
        su.username,
        suc.username AS check_user_name,
        COALESCE(pw.rank_id, up.rank_id) as rank_id,
        su.region,
        su.nation,
        su.country,
        su.city,
        su.real_name,
        su.create_time AS register_time,
        su.status,
        ua.username AS agent_name,
        ut.username AS general_agent_name,
        sul.username AS lock_person_name,
        ua.id AS agent_id,
        pt.origin,
        pr.risk_marker,
        pr.rank_name,
        ((pw.deduct_favorable + pw.counter_fee) + pw.administrative_fee) AS deduct_sum
   FROM player_withdraw pw
   LEFT JOIN user_player up ON up.id = pw.player_id
   LEFT JOIN sys_user su ON pw.player_id = su.id
   LEFT JOIN sys_user ua ON ua.id = su.owner_id
   LEFT JOIN sys_user ut ON ut.id = ua.owner_id
   LEFT JOIN sys_user sul ON sul.id = pw.lock_person_id
   LEFT JOIN sys_user suc ON pw.check_user_id = suc.id
   LEFT JOIN player_transaction pt ON pw.player_transaction_id = pt.id
   LEFT JOIN player_rank pr ON COALESCE(pw.rank_id, up.rank_id) = pr.id;


UPDATE player_transaction set rank_id=user_player.rank_id FROM user_player WHERE player_transaction.rank_id IS NULL and player_transaction.player_id=user_player.id;

CREATE OR REPLACE VIEW v_player_deposit AS
 SELECT pr.id,
        pr.player_id,
        su.username,
        COALESCE(pt.rank_id, up.rank_id) as rank_id,
        pr.create_time,
        pr.recharge_type,
        pr.is_first_recharge,
        pr.payer_bank,
        pr.payer_bankcard,
        pr.bank_order,
        pr.recharge_address,
        pr.pay_account_id,
        pa.bank_code,
        pa.full_name,
        pr.counter_fee,
        su.default_currency,
        pr.recharge_amount,
        pr.recharge_total_amount,
        pr.check_status,
        pr.recharge_status,
        pr.check_user_id,
        pr.check_username,
        pr.check_time,
        pr.payer_name,
        pr.transaction_no,
        pa.custom_bank_name,
        pa.account,
        pr.recharge_type_parent,
        pr.check_remark,
        pr.failure_title,
        pa.status AS pay_account_status,
        pa.deposit_count,
        up.recharge_count,
        pr.ip_deposit,
        pr.ip_dict_code,
        pr.pay_url,
        pt.origin,
        pa.pay_name,
        ra.rank_name,
        ra.risk_marker,
        pa.account_type,
        pa.channel_json,
        pr.favorable_total_amount
   FROM player_recharge pr
   LEFT JOIN sys_user su ON pr.player_id = su.id
   LEFT JOIN user_player up ON pr.player_id = up.id
   LEFT JOIN pay_account pa ON pr.pay_account_id = pa.id
   LEFT JOIN player_transaction pt ON pr.transaction_no = pt.transaction_no
   LEFT JOIN player_rank ra ON ra.id = COALESCE(pt.rank_id, up.rank_id);