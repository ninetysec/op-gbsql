-- auto gen by cheery 2015-12-23 18:18:11
DROP VIEW IF EXISTS v_player_transaction;
DROP VIEW IF EXISTS v_player_withdraw;

ALTER TABLE "player_transaction" ALTER COLUMN "remark" TYPE varchar(300) COLLATE "default";

CREATE OR REPLACE VIEW v_player_transaction as
 SELECT pt.id,
    pt.transaction_no,
    pt.create_time,
    pt.transaction_type,
    pt.remark,
    pt.transaction_money,
    pt.balance,
    pt.status,
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
    su.username
   FROM (player_transaction pt
     LEFT JOIN sys_user su ON ((pt.player_id = su.id)));

CREATE OR REPLACE VIEW v_player_withdraw AS
 SELECT t1.id,
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
    t4.withdraw_count AS success_count,
    (date_part('epoch'::text, ((t1.check_closing_time)::timestamp with time zone - now())) / (60)::double precision) AS closing_time,
    p.remark,
    t2.username,
    t3.username AS check_user_name,
    t4.rank_id,
    t2.region,
    t2.nation,
    t2.country,
    t2.city,
    t2.real_name,
    t2.create_time AS register_time,
    t2.status,
    t5.risk_marker,
    t5.rank_name,
    t6.username AS agent_name,
    t9.username AS general_agent_name,
    t10.username AS lock_person_name
   FROM ((((((((player_withdraw t1
     LEFT JOIN user_player t4 ON ((t4.id = t1.player_id)))
     LEFT JOIN sys_user t2 ON ((t4.id = t2.id)))
     LEFT JOIN player_transaction p ON ((t1.player_transaction_id = p.id)))
     LEFT JOIN sys_user t3 ON ((t1.check_user_id = t3.id)))
     LEFT JOIN player_rank t5 ON ((t5.id = t4.rank_id)))
     LEFT JOIN sys_user t6 ON ((t6.id = t2.owner_id)))
     LEFT JOIN sys_user t10 ON ((t10.id = t1.lock_person_id)))
     LEFT JOIN sys_user t9 ON ((t9.id = t6.owner_id)));

DROP FUNCTION if EXISTS f_deposit_amount(integer, numeric);

select redo_sqls($$
ALTER TABLE "player_recommend_award" ADD COLUMN "reward_reason" varchar(32);
$$);

COMMENT ON COLUMN "player_recommend_award"."reward_reason" IS '奖励原因recommend.reward_reason(推荐,被推荐)';




DROP table IF EXISTS site_contracts_notice;

drop VIEW IF EXISTS v_agent_fund_record;

ALTER TABLE "agent_rebate_order" DROP COLUMN IF EXISTS "settlement_name";
ALTER TABLE "agent_rebate_order" DROP COLUMN IF EXISTS "start_time";
ALTER TABLE "agent_rebate_order" DROP COLUMN IF EXISTS "end_time";

CREATE OR REPLACE VIEW v_agent_fund_record AS
 SELECT a.id,
    a.transaction_no,
    a.agent_id,
    a.create_time,
    b.transaction_money,
    b.balance,
        CASE a.settlement_state
            WHEN 'pending_lssuing'::text THEN '1'::text
            WHEN 'lssuing'::text THEN '2'::text
            WHEN 'reject_lssuing'::text THEN '4'::text
            ELSE 'ONO'::text
        END AS status,
    1 AS type,
    a.period AS periods,
    a.start_time
   FROM
	(select o.*, b.start_time,b.end_time,b.create_time AS bill_create_time,b.period from agent_rebate_order o left join rebate_bill b on o.rebate_bill_id = b.id) as a
     LEFT JOIN agent_water_bill b ON a.id = b.order_id
  WHERE a.settlement_state::text = 'lssuing'::text
UNION
 SELECT a.id,
    a.transaction_no,
    a.agent_id,
    a.create_time,
    b.transaction_money,
    b.balance,
    a.transaction_status AS status,
    2 AS type,
    ''::character varying AS periods,
    now() AS start_time
   FROM agent_withdraw_order a
     LEFT JOIN agent_water_bill b ON a.id = b.order_id;

ALTER TABLE v_agent_fund_record OWNER TO postgres;
COMMENT ON VIEW v_agent_fund_record IS '代理资金账户流水--susu';




