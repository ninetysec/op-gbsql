-- auto gen by admin 2016-04-16 20:40:43
DROP VIEW if EXISTS v_pay_rank;
DROP VIEW  if EXISTS v_player_transaction;
DROP VIEW  if EXISTS v_pay_account;
DROP VIEW  if EXISTS v_player_recharge;

ALTER TABLE pay_account  ALTER COLUMN pay_key TYPE character varying(200);

COMMENT ON COLUMN pay_account.pay_key IS 'Key';

CREATE OR REPLACE VIEW v_pay_rank AS
 SELECT a.id,
    a.player_rank_id,
    a.pay_account_id,
    a.create_time,
    a.create_user,
    b.pay_name,
    b.account,
    b.full_name,
    b.disable_amount,
    b.pay_key,
    b.status,
    b.create_time AS pay_create_time,
    b.create_user AS pay_create_user,
    b.type,
    b.account_type,
    b.bank_code,
    b.pay_url,
    b.code,
    b.deposit_count,
    b.deposit_total,
    b.deposit_default_count,
    b.deposit_default_total,
    b.single_deposit_min,
    b.single_deposit_max,
    b.effective_minutes,
    '' AS bank_icon,
    '' AS bank_district,
    '' AS bank_type
   FROM pay_rank a
     LEFT JOIN pay_account b ON a.pay_account_id = b.id
  ORDER BY b.account_type, b.bank_code;
COMMENT ON VIEW v_pay_rank
  IS '玩家层级对应支付限制视图';


CREATE OR REPLACE VIEW v_player_transaction AS
 SELECT pt.id,
    pt.transaction_no,
    pt.create_time,
    pt.transaction_type,
    pt.remark,
    pt.transaction_money,
    pt.balance,
        CASE
            WHEN pt.status::text = 'pending_pay'::text AND (pt.create_time + ((pa.effective_minutes || ' minute'::text)::interval)) <= now() THEN 'over_time'::character varying
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
    topagentuser.username AS topagentusername
   FROM player_transaction pt
     LEFT JOIN sys_user su ON pt.player_id = su.id
     LEFT JOIN sys_user agentuser ON su.owner_id = agentuser.id
     LEFT JOIN sys_user topagentuser ON agentuser.owner_id = topagentuser.id
     LEFT JOIN player_recharge pr ON pr.id = pt.source_id AND pt.fund_type::text = 'online_deposit'::text
     LEFT JOIN pay_account pa ON pa.id = pr.pay_account_id;


CREATE OR REPLACE VIEW v_pay_account AS
 SELECT pa.id,
    pa.pay_name,
    pa.account,
    pa.full_name,
    pa.disable_amount,
    pa.pay_key,
    pa.status,
    pa.create_time,
    pa.create_user,
    pa.type,
    pa.account_type,
    pa.bank_code,
    pa.pay_url,
    pa.code,
    pa.deposit_count,
    pa.deposit_total,
    pa.deposit_default_count,
    pa.deposit_default_total,
    pa.single_deposit_min,
    pa.single_deposit_max,
    pa.effective_minutes,
    pa.full_rank,
    ( SELECT count(1) AS count
           FROM ( SELECT r.pay_account_id
                   FROM pay_rank r
                     JOIN player_rank k ON r.player_rank_id = k.id) pr
          WHERE pr.pay_account_id = pa.id) AS pay_rank_num,
    ( SELECT count(1) AS recharge_num
           FROM player_recharge pr
          WHERE pr.pay_account_id = pa.id AND (pr.recharge_status::text = '2'::text OR pr.recharge_status::text = '5'::text)) AS recharge_num,
    ( SELECT sum(pr.recharge_amount) AS recharge_amount
           FROM player_recharge pr
          WHERE pr.pay_account_id = pa.id AND (pr.recharge_status::text = '2'::text OR pr.recharge_status::text = '5'::text)) AS recharge_amount,
    ( SELECT max(COALESCE(pr.create_time, to_date('1900-1-1'::text, 'yyyy-MM-dd'::text)::timestamp without time zone)) AS max
           FROM player_recharge pr
          WHERE pr.pay_account_id = pa.id AND (pr.recharge_status::text = '2'::text OR pr.recharge_status::text = '5'::text)) AS last_recharge
   FROM pay_account pa;


CREATE OR REPLACE VIEW v_player_recharge AS
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
        CASE
            WHEN t1.recharge_status::text = '4'::text AND (t1.create_time + ((t5.effective_minutes || ' minute'::text)::interval)) <= now() THEN '7'::character varying
            ELSE t1.recharge_status
        END AS recharge_status,
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
    t6.risk_marker
   FROM player_recharge t1
     LEFT JOIN sys_user t2 ON t1.player_id = t2.id
     LEFT JOIN sys_user t3 ON t1.check_user_id = t3.id
     LEFT JOIN user_player t4 ON t4.id = t1.player_id
     LEFT JOIN pay_account t5 ON t1.pay_account_id = t5.id
     LEFT JOIN player_rank t6 ON t6.id = t4.rank_id;



