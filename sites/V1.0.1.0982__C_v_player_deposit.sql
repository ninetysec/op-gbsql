-- auto gen by steffan 2018-09-13 19:37:18
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
    pr.player_transaction_id,
    pr.receive_account,
    pr.receive_name,
    pr.fee_flag
   FROM (((((player_recharge pr
     LEFT JOIN sys_user su ON ((pr.player_id = su.id)))
     LEFT JOIN user_player up ON ((pr.player_id = up.id)))
     LEFT JOIN pay_account pa ON ((pr.pay_account_id = pa.id)))
     LEFT JOIN player_transaction pt ON (((pr.transaction_no)::text = (pt.transaction_no)::text)))
     LEFT JOIN player_rank ra ON ((ra.id = COALESCE(pt.rank_id, up.rank_id))));


COMMENT ON VIEW "v_player_deposit" IS 'Fei - 玩家存款列表视图';