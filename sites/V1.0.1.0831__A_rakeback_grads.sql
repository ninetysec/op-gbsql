-- auto gen by steffan 2018-05-23 11:42:44

--更新字段长度
select redo_sqls($$
	ALTER TABLE "rakeback_grads" ALTER COLUMN "valid_value" TYPE int8;
	ALTER TABLE "rakeback_grads" ALTER COLUMN "max_rakeback" TYPE int8;

$$);



DROP VIEW IF EXISTS v_rebate_agent;
select redo_sqls($$
	ALTER TABLE "rebate_set" ALTER COLUMN "valid_value" TYPE int8;
$$);

CREATE OR REPLACE VIEW "v_rebate_agent" AS
 SELECT rs.id,
    rs.name,
    rs.status,
    rs.valid_value,
    rs.remark,
    rs.create_time,
    rs.create_user_id,
    ( SELECT count(1) AS count
           FROM user_agent_rebate
          WHERE (rs.id = user_agent_rebate.rebate_id)) AS rebatenum
   FROM rebate_set rs;
COMMENT ON VIEW "v_rebate_agent" IS '代理返佣younger';


DROP VIEW IF EXISTS v_player_rank_statistics;
DROP VIEW IF EXISTS v_pay_account;
DROP VIEW IF EXISTS v_pay_rank;
select redo_sqls($$
	ALTER TABLE "player_rank" ALTER COLUMN "online_pay_min" TYPE int8;
	ALTER TABLE "player_rank" ALTER COLUMN "online_pay_max" TYPE int8;

	ALTER TABLE "pay_account" ALTER COLUMN "single_deposit_min" TYPE int8;
	ALTER TABLE "pay_account" ALTER COLUMN "single_deposit_max" TYPE int8;
$$);

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
           FROM ( SELECT DISTINCT t.pay_account_id
                   FROM ( SELECT pra.pay_account_id
                           FROM (pay_rank pra
                             LEFT JOIN pay_account pa ON ((pra.pay_account_id = pa.id)))
                          WHERE (((pa.status)::text <> '4'::text) AND (pra.player_rank_id = pr.id))
                        UNION ALL
                         SELECT pay_account.id AS pay_account_id
                           FROM pay_account
                          WHERE ((pay_account.full_rank = true) AND ((pay_account.status)::text <> '4'::text))) t) t2) AS pay_account_num,
    pr.rakeback_id,
    rs.name AS rakeback_name,
    ( SELECT count(*) AS count
           FROM user_agent
          WHERE ((user_agent.player_rank_id = pr.id) AND (user_agent.parent_id IS NOT NULL))) AS agent_num,
    pr.is_withdraw_fee_zero_reset
   FROM (player_rank pr
     LEFT JOIN rakeback_set rs ON ((pr.rakeback_id = rs.id)))
  WHERE ((pr.status)::text = '1'::text);

COMMENT ON VIEW "v_player_rank_statistics" IS '层级设置视图 - Edit by Bruce,modify by steffan,younger';

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
    pa.remark,
    pa.frozen_time,
    pa.alias_name,
    pa.support_atm_counter,
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
COMMENT ON VIEW "v_pay_account" IS '公司、线上入款账号视图--edit by linsen younger';

CREATE OR REPLACE VIEW "v_pay_rank" AS
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
    ''::text AS bank_icon,
    ''::text AS bank_district,
    ''::text AS bank_type
   FROM (pay_rank a
     LEFT JOIN pay_account b ON ((a.pay_account_id = b.id)))
  ORDER BY b.account_type, b.bank_code;
COMMENT ON VIEW "v_pay_rank" IS '玩家层级对应支付限制视图 edit by younger';

DROP VIEW IF EXISTS v_agent_rebate_scheme;
select redo_sqls($$
	ALTER TABLE "rebate_grads" ALTER COLUMN "total_profit" TYPE int8;
	ALTER TABLE "rebate_grads" ALTER COLUMN "max_rebate" TYPE int8;
$$);

CREATE OR REPLACE VIEW "v_agent_rebate_scheme" AS
 SELECT rg.id,
    rg.total_profit,
    rg.valid_player_num,
    rg.max_rebate,
    api.api_id,
    api.game_type,
    api.ratio,
    ua.id AS agent_id,
    rs.id AS rebate_id
   FROM ((((user_agent ua
     LEFT JOIN user_agent_rebate uar ON ((ua.id = uar.user_id)))
     LEFT JOIN rebate_set rs ON ((uar.rebate_id = rs.id)))
     LEFT JOIN rebate_grads rg ON ((rs.id = rg.rebate_id)))
     LEFT JOIN ( SELECT rga.api_id,
            rga.game_type,
            rga.ratio,
            rga.rebate_grads_id
           FROM (rebate_grads rg_1
             LEFT JOIN rebate_grads_api rga ON ((rg_1.id = rga.rebate_grads_id)))) api ON ((rg.id = api.rebate_grads_id)))
  ORDER BY rg.id, api.api_id, api.game_type;
COMMENT ON VIEW "v_agent_rebate_scheme" IS '代理返佣方案视图 - Fly';
