-- auto gen by cherry 2017-03-20 21:00:29
DROP VIEW v_player_rank_statistics;

DROP VIEW IF EXISTS v_player_rank_statistics;
CREATE OR REPLACE VIEW "v_player_rank_statistics" AS
   SELECT pr.id,
      pr.rank_name,
      pr.rank_code,
      pr.risk_marker,
      pr.create_user,
      pr.create_time,
      pr.remark,
      pr.online_pay_min,
      pr.online_pay_max,
      pr.is_fee,
      pr.fee_time,
      pr.free_count,
      pr.max_fee,
      pr.fee_type,
      pr.fee_money,
      pr.is_return_fee,
      pr.reach_money,
      pr.max_return_fee,
      pr.return_time,
      pr.return_fee_count,
      pr.return_type,
      pr.return_money,
      pr.withdraw_time_limit,
      pr.withdraw_free_count,
      pr.withdraw_max_fee,
      pr.withdraw_fee_type,
      pr.withdraw_fee_num,
      pr.withdraw_check_status,
      pr.withdraw_check_time,
      pr.withdraw_excess_check_status,
      pr.withdraw_excess_check_num,
      pr.withdraw_excess_check_time,
      pr.withdraw_max_num,
      pr.withdraw_min_num,
      pr.withdraw_normal_audit,
      pr.withdraw_admin_cost,
      pr.withdraw_relax_credit,
      pr.withdraw_discount_audit,
      pr.is_withdraw_limit,
      pr.withdraw_count,
      pr.built_in,
      pr.status,
      pr.is_take_turns,
      pr.take_turns,
      pr.favorable_audit,
      ( SELECT count(1) AS count
             FROM (user_player a
               JOIN sys_user b ON ((a.id = b.id)))
            WHERE (a.rank_id = pr.id)) AS player_num,
      ( SELECT
			COUNT (1)
		FROM
			(
				SELECT DISTINCT
					(pay_account_id)
				FROM
					(
						SELECT
							pra.pay_account_id
						FROM
							pay_rank pra
						LEFT JOIN pay_account pa ON pra.pay_account_id = pa. ID
						WHERE
							pa.status != '4'
						AND player_rank_id = pr.id
						UNION ALL
							SELECT
								ID AS pay_account_id
							FROM
								pay_account
							WHERE
								full_rank = 't'
							AND status != '4'
					) AS T
			) AS t2) AS pay_account_num,
      pr.rakeback_id,
      rs.name AS rakeback_name,
      (SELECT "count"(*) FROM user_agent WHERE user_agent.player_rank_id = pr.id AND user_agent.parent_id is NOT NULL ) AS agent_num
     FROM (player_rank pr
       LEFT JOIN rakeback_set rs ON ((pr.rakeback_id = rs.id)))
    WHERE ((pr.status)::text = '1'::text);

COMMENT ON VIEW "v_player_rank_statistics" IS '层级设置视图 - Edit by Bruce';