-- auto gen by fei 2016-07-13 20:40:01
DROP VIEW IF EXISTS v_player_deposit;
CREATE OR REPLACE VIEW v_player_deposit AS
 SELECT pr."id",
		pr.player_id,
		su.username,
		up.rank_id,
	    ra.rank_name,
		ra.risk_marker,
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
            WHEN pr.recharge_status = '4' AND (pr.create_time + (pa.effective_minutes || ' minute')::interval) <= now() THEN '7'
            ELSE pr.recharge_status
        END as recharge_status,
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
        pa.status as pay_account_status,
        pa.deposit_count,
        up.recharge_count
   FROM player_recharge pr
   LEFT JOIN sys_user su ON pr.player_id = su."id"
   LEFT JOIN user_player up ON pr.player_id = up."id"
   LEFT JOIN player_rank ra ON up.rank_id = ra."id"
   LEFT JOIN pay_account pa ON pr.pay_account_id = pa."id";

COMMENT ON VIEW v_player_deposit IS 'Fei - 玩家存款列表视图';
