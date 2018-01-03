-- auto gen by cherry 2017-07-27 17:24:54
DROP VIEW if EXISTS v_player_recharge ;
DROP VIEW IF EXISTS v_player_deposit;

ALTER TABLE player_recharge ALTER COLUMN failure_title type varchar(256);

CREATE OR REPLACE VIEW "v_player_recharge" AS
 SELECT t1.id,
    t1.player_id,
    t1.player_transaction_id,
    t1.transaction_no,
    t1.recharge_amount,
    t1.recharge_remark,
    t1.favorable_total_amount,
    t1.is_counter_fee,
    t1.counter_fee_path,
    t1.cf_ratio_or_fixed,
    t1.counter_fee,
    t1.is_audit_recharge,
    t1.recharge_type,
    t1.is_related_order,
    t1.related_order_id,
    t1.payer_bank,
    t1.payer_name,
    t1.payer_bankcard,
    t1.create_time,
    t1.check_time,
    t1.check_user_id,
    t1.check_remark,
    t1.check_status,
    t1.bank_order,
    t1.return_time,
    t1.payer_bank_type,
    t1.is_first_recharge,
    t1.counterfee_remark,
    t1.is_favorable,
    t1.pay_account_id,
    t1.related_transaction_no,
    t1.cf_ratio_or_fixed_value,
    t1.return_recharge,
    t1.is_return_recharge,
    t1.artificial_reason_content,
    t1.recharge_type_parent,
    t1.recharge_total_amount,
    t1.failure_title,
    t1.artificial_reason_title,
    t1.receive_account,
    t1.receive_name,
    t1.master_bank_type,
    t1.recharge_status,
    t2.username,
    t3.username AS check_user_name,
    t2.default_currency AS main_currency,
    t2.nation,
    t4.recharge_count,
    t5.account AS master_bank_card,
    t5.pay_name AS master_name,
    t5.status AS master_bankcard_status,
    t5.bank_code AS master_bank,
    t2.default_timezone,
    t6.risk_marker,
    t7.fund_type,
    t1.recharge_address
   FROM ((((((player_recharge t1
     LEFT JOIN sys_user t2 ON ((t1.player_id = t2.id)))
     LEFT JOIN sys_user t3 ON ((t1.check_user_id = t3.id)))
     LEFT JOIN user_player t4 ON ((t4.id = t1.player_id)))
     LEFT JOIN pay_account t5 ON ((t1.pay_account_id = t5.id)))
     LEFT JOIN player_rank t6 ON ((t6.id = t4.rank_id)))
     LEFT JOIN player_transaction t7 ON ((t1.player_transaction_id = t7.id)));

COMMENT ON VIEW "v_player_recharge" IS '玩家资金视图edit by younger';

CREATE OR REPLACE VIEW "v_player_deposit" AS
 SELECT pr.id,
    pr.player_id,
    su.username,
    COALESCE(pt.rank_id, up.rank_id) AS rank_id,
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
    pr.favorable_total_amount,
    pr.return_time,
    pr.bit_amount,
    pr.player_transaction_id
   FROM (((((player_recharge pr
     LEFT JOIN sys_user su ON ((pr.player_id = su.id)))
     LEFT JOIN user_player up ON ((pr.player_id = up.id)))
     LEFT JOIN pay_account pa ON ((pr.pay_account_id = pa.id)))
     LEFT JOIN player_transaction pt ON (((pr.transaction_no)::text = (pt.transaction_no)::text)))
     LEFT JOIN player_rank ra ON ((ra.id = COALESCE(pt.rank_id, up.rank_id))));

COMMENT ON VIEW "v_player_deposit" IS 'Fei - 玩家存款列表视图';