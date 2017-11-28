-- auto gen by admin 2016-05-16 21:57:18
 select redo_sqls($$
       ALTER TABLE rakeback_player ADD COLUMN audit_num numeric(20,2);

ALTER TABLE rakeback_player_nosettled ADD COLUMN audit_num numeric(20,2);

ALTER TABLE ctt_float_pic ADD COLUMN distance_bottom integer;

ALTER TABLE ctt_float_pic ALTER COLUMN distance_top DROP NOT NULL;

alter table pay_account ADD COLUMN open_acount_name varchar(100);
 $$);

--ALTER TABLE user_agent_rakeback Drop CONSTRAINT if EXISTS uq_user_agent_rakeback_user_id;
--ALTER TABLE user_agent_rakeback ADD CONSTRAINT uq_user_agent_rakeback_user_id UNIQUE(user_id);
COMMENT ON COLUMN ctt_float_pic.distance_bottom IS '底边距';
COMMENT ON COLUMN ctt_float_pic.distance_top IS '顶边距';
COMMENT ON COLUMN rakeback_player_nosettled.audit_num IS '优惠稽核';
COMMENT ON COLUMN rakeback_player.audit_num IS '优惠稽核';

--添加pay_account 字段；
DROP VIEW IF EXISTS "v_pay_account";

COMMENT ON COLUMN "pay_account"."open_acount_name" IS '开户行';

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
