-- auto gen by cherry 2016-10-23 21:41:50
drop view if EXISTS v_player_withdraw;

CREATE OR REPLACE VIEW "v_player_withdraw" AS

 select a.*,pr.risk_marker,

    pr.rank_name from (SELECT t1.id,

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

    case when t1.rank_id is null then t4.rank_id else t1.rank_id end rank_id,

    t2.region,

    t2.nation,

    t2.country,

    t2.city,

    t2.real_name,

    t2.create_time AS register_time,

    t2.status,

    t6.username AS agent_name,

    t9.username AS general_agent_name,

    t10.username AS lock_person_name,

    t6.id AS agent_id,

    p.origin

   FROM ((((((((player_withdraw t1

     LEFT JOIN user_player t4 ON ((t4.id = t1.player_id)))

     LEFT JOIN sys_user t2 ON ((t4.id = t2.id)))

     LEFT JOIN player_transaction p ON ((t1.player_transaction_id = p.id)))

     LEFT JOIN sys_user t3 ON ((t1.check_user_id = t3.id)))  )

     LEFT JOIN sys_user t6 ON ((t6.id = t2.owner_id)))

     LEFT JOIN sys_user t10 ON ((t10.id = t1.lock_person_id)))

     LEFT JOIN sys_user t9 ON ((t9.id = t6.owner_id)))) a left join player_rank pr on a.rank_id=pr.id;





COMMENT ON VIEW "v_player_withdraw" IS '玩家交易表视图 edit by river重建';









drop view if EXISTS v_player_deposit;

CREATE OR REPLACE VIEW "v_player_deposit" AS

 select a.*,

    ra.rank_name,

    ra.risk_marker from (SELECT pr.id,

    pr.player_id,

    su.username,

    case when pt.rank_id is null then up.rank_id ELSE pt.rank_id end rank_id,

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

        CASE

            WHEN (((pr.recharge_status)::text = '4'::text) AND ((pr.create_time + ((pa.effective_minutes || ' minute'::text))::interval) <= now())) THEN '7'::character varying

            ELSE pr.recharge_status

        END AS recharge_status,

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

    pa.pay_name

   FROM (((((player_recharge pr

     LEFT JOIN sys_user su ON ((pr.player_id = su.id)))

     LEFT JOIN user_player up ON ((pr.player_id = up.id)))

     LEFT JOIN pay_account pa ON ((pr.pay_account_id = pa.id)))

     LEFT JOIN player_transaction pt ON (((pr.transaction_no)::text = (pt.transaction_no)::text))))) a

     LEFT JOIN player_rank ra ON ra.id = a.rank_id;

COMMENT ON VIEW "v_player_deposit" IS 'Fei - 玩家存款列表视图';