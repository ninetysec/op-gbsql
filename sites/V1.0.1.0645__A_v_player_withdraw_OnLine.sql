-- auto gen by water 2017-12-28 14:27:36


drop VIEW if EXISTS v_player_withdraw;

CREATE VIEW v_player_withdraw AS SELECT pw.id,
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
                                   COALESCE(pw.rank_id, up.rank_id) AS rank_id,
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
                                   pw.remittance_way,
                                   pw.bit_amount,
                                   ((pw.deduct_favorable + pw.counter_fee) + pw.administrative_fee) AS deduct_sum,
                                   (((su.login_time > su.last_logout_time) OR (su.last_logout_time IS NULL)) AND (su.last_active_time > (now() - '00:30:00'::interval))) AS on_line
                                 FROM ((((((((player_withdraw pw
                                   LEFT JOIN user_player up ON ((up.id = pw.player_id)))
                                   LEFT JOIN sys_user su ON ((pw.player_id = su.id)))
                                   LEFT JOIN sys_user ua ON ((ua.id = su.owner_id)))
                                   LEFT JOIN sys_user ut ON ((ut.id = ua.owner_id)))
                                   LEFT JOIN sys_user sul ON ((sul.id = pw.lock_person_id)))
                                   LEFT JOIN sys_user suc ON ((pw.check_user_id = suc.id)))
                                   LEFT JOIN player_transaction pt ON ((pw.player_transaction_id = pt.id)))
                                   LEFT JOIN player_rank pr ON ((COALESCE(pw.rank_id, up.rank_id) = pr.id)));
COMMENT ON VIEW v_player_withdraw IS '玩家交易表视图 edit by river重建';

