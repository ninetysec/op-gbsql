-- auto gen by cherry 2017-03-01 14:28:30
DROP VIEW IF EXISTS v_pay_account;
DROP VIEW IF EXISTS v_pay_rank;
ALTER TABLE pay_account ALTER COLUMN disable_amount type int4;
UPDATE sys_resource SET url='home/Index.html' WHERE id=31;

CREATE VIEW v_pay_account AS
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
    pa.open_acount_name,
    pa.qr_code_url,
    pa.channel_json,
    pa.remark,
    pa.frozen_time,
    ( SELECT count(1) AS count
           FROM ( SELECT r.pay_account_id
                   FROM (pay_rank r
                     JOIN player_rank k ON ((r.player_rank_id = k.id)))
                  WHERE ((k.withdraw_min_num IS NOT NULL) AND (k.online_pay_max IS NOT NULL))) pr
          WHERE (pr.pay_account_id = pa.id)) AS pay_rank_num,
    ( SELECT count(1) AS recharge_num
           FROM player_recharge pr
          WHERE ((pr.pay_account_id = pa.id) AND (((pr.recharge_status)::text = '2'::text) OR ((pr.recharge_status)::text = '5'::text)))) AS recharge_num,
    ( SELECT sum(pr.recharge_amount) AS recharge_amount
           FROM player_recharge pr
          WHERE ((pr.pay_account_id = pa.id) AND (((pr.recharge_status)::text = '2'::text) OR ((pr.recharge_status)::text = '5'::text)))) AS recharge_amount,
    ( SELECT max(COALESCE(pr.create_time, (to_date('1900-1-1'::text, 'yyyy-MM-dd'::text))::timestamp without time zone)) AS max
           FROM player_recharge pr
          WHERE ((pr.pay_account_id = pa.id) AND (((pr.recharge_status)::text = '2'::text) OR ((pr.recharge_status)::text = '5'::text)))) AS last_recharge
   FROM pay_account pa;


COMMENT ON VIEW "v_pay_account" IS '公司、线上入款账号视图--edit by younger';





CREATE VIEW v_pay_rank AS
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
   FROM (pay_rank a
     LEFT JOIN pay_account b ON ((a.pay_account_id = b.id)))
  ORDER BY b.account_type, b.bank_code;


COMMENT ON VIEW v_pay_rank IS '玩家层级对应支付限制视图';