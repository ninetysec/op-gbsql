-- auto gen by cherry 2016-09-04 10:01:19
DROP VIEW IF EXISTS v_player_transaction ;

ALTER TABLE player_transaction ALTER COLUMN transaction_data type VARCHAR(256);

CREATE OR REPLACE VIEW "v_player_transaction" AS
 SELECT pt.id,
    pt.transaction_no,
    pt.create_time,
    pt.transaction_type,
    pt.remark,
    pt.transaction_money,
    pt.balance,
        CASE
            WHEN (((pt.status)::text = 'pending_pay'::text) AND ((pt.create_time + ((pa.effective_minutes || ' minute'::text))::interval) <= now())) THEN 'over_time'::character varying
            ELSE pt.status
        END AS status,
    pt.player_id,
    pt.failure_reason,
    pt.source_id,
    pt.effective_transaction,
    pt.recharge_audit_points,
    pt.relaxing_quota,
    pt.administrative_fee,
    pt.favorable_total_amount,
    pt.favorable_audit_points,
    pt.deduct_favorable,
    pt.is_satisfy_audit,
    pt.is_clear_audit,
    pt.api_money,
    pt.completion_time,
    pt.fund_type,
    pt.transaction_way,
    pt.transaction_data,
    su.username,
    su.user_type,
    agentuser.username AS agentname,
    agentuser.id AS agentid,
    topagentuser.id AS topagentid,
    topagentuser.username AS topagentusername,
    pr.is_first_recharge,
    pr.payer_bankcard,
    pr.recharge_total_amount,
    pr.recharge_amount,
    pr.recharge_address,
    pf.api_id
   FROM ((((((player_transaction pt
     LEFT JOIN sys_user su ON ((pt.player_id = su.id)))
     LEFT JOIN sys_user agentuser ON ((su.owner_id = agentuser.id)))
     LEFT JOIN sys_user topagentuser ON ((agentuser.owner_id = topagentuser.id)))
     LEFT JOIN player_recharge pr ON ((pr.id = pt.source_id)))
     LEFT JOIN pay_account pa ON ((pa.id = pr.pay_account_id)))
     LEFT JOIN player_transfer pf ON ((pf.id = pt.source_id)));

COMMENT ON VIEW "v_player_transaction" IS '玩家交易视图edit by younger';

 select redo_sqls($$
	alter table player_rank add COLUMN rakeback_id INTEGER;
$$);

COMMENT ON COLUMN player_rank.rakeback_id is '返水方案';

drop view if EXISTS v_player_rank_statistics;

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

    ( SELECT count(1) AS count

           FROM pay_rank

          WHERE (pay_rank.player_rank_id = pr.id)) AS pay_account_num,

    pr.rakeback_id,

    rs.name rakeback_name

   FROM player_rank pr left join rakeback_set rs on pr.rakeback_id=rs.id

  WHERE ((pr.status)::text = '1'::text);

