-- auto gen by george 2017-12-05 11:24:46

DROP VIEW IF EXISTS v_player_recharge;

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
    t1.recharge_address,
	t4.user_agent_id AS agentid
   FROM ((((((player_recharge t1
     LEFT JOIN sys_user t2 ON ((t1.player_id = t2.id)))
     LEFT JOIN sys_user t3 ON ((t1.check_user_id = t3.id)))
     LEFT JOIN user_player t4 ON ((t4.id = t1.player_id)))
     LEFT JOIN pay_account t5 ON ((t1.pay_account_id = t5.id)))
     LEFT JOIN player_rank t6 ON ((t6.id = t4.rank_id)))
     LEFT JOIN player_transaction t7 ON ((t1.player_transaction_id = t7.id)));

COMMENT ON VIEW "v_player_recharge" IS '玩家资金视图edit by linsen';

