-- auto gen by cherry 2016-03-08 14:36:43

DELETE FROM notice_email_interface WHERE built_in=true;

INSERT INTO notice_email_interface ("id", "user_group_type", "user_group_id", "server_address", "server_port", "email_account", "account_password", "built_in", "name", "create_time", "update_time", "send_count", "status", "reply_email_account", "test_email_account")
SELECT '-1', 'rank', '0', '192.168.0.11', '', 'Mark@wwb.so', '┼41f87b2cbe2eb0ec7c09ddf82a7c7c12', 't', '默认接口', '2015-08-26 14:14:14', NULL, '0', '1', NULL, NULL
where  '-1' not in (SELECT id FROM notice_email_interface WHERE id='-1');

UPDATE sys_param SET default_value='0' WHERE param_type='apportionSetting';

DROP VIEW IF EXISTS v_pay_account;
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
                   FROM (pay_rank r
                     JOIN player_rank k ON ((r.player_rank_id = k.id)))) pr
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
