-- auto gen by cherry 2016-07-15 10:28:16
drop VIEW if EXISTS v_pay_account;

CREATE OR REPLACE VIEW "v_pay_account" AS
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