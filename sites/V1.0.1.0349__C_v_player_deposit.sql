-- auto gen by cherry 2016-12-12 11:36:23
DROP view IF EXISTS v_player_deposit;

CREATE
OR REPLACE VIEW "v_player_deposit" AS SELECT
	A . ID,
	A .player_id,
	A .username,
	A .rank_id,
	A .create_time,
	A .recharge_type,
	A .is_first_recharge,
	A .payer_bank,
	A .payer_bankcard,
	A .bank_order,
	A .recharge_address,
	A .pay_account_id,
	A .bank_code,
	A .full_name,
	A .counter_fee,
	A .default_currency,
	A .recharge_amount,
	A .recharge_total_amount,
	A .check_status,
	A .recharge_status,
	A .check_user_id,
	A .check_username,
	A .check_time,
	A .payer_name,
	A .transaction_no,
	A .custom_bank_name,
	A .account,
	A .recharge_type_parent,
	A .check_remark,
	A .failure_title,
	A .pay_account_status,
	A .deposit_count,
	A .recharge_count,
	A .ip_deposit,
	A .ip_dict_code,
	A .pay_url,
	A .origin,
	A .pay_name,
	ra.rank_name,
	ra.risk_marker,
	A .account_type,
	A .channel_json,
	A .favorable_total_amount
FROM
	(
		(
			SELECT
				pr. ID,
				pr.player_id,
				su.username,
				CASE
			WHEN (pt.rank_id IS NULL) THEN
				up.rank_id
			ELSE
				pt.rank_id
			END AS rank_id,
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
			pa.account_type,
			pa.channel_json,
			pr.favorable_total_amount
		FROM
			(
				(
					(
						(
							player_recharge pr
							LEFT JOIN sys_user su ON ((pr.player_id = su. ID))
						)
						LEFT JOIN user_player up ON ((pr.player_id = up. ID))
					)
					LEFT JOIN pay_account pa ON ((pr.pay_account_id = pa. ID))
				)
				LEFT JOIN player_transaction pt ON (
					(
						(pr.transaction_no) :: TEXT = (pt.transaction_no) :: TEXT
					)
				)
			)
		) A
		LEFT JOIN player_rank ra ON ((ra. ID = A .rank_id))
	);

COMMENT ON VIEW "v_player_deposit" IS 'Fei - 玩家存款列表视图';