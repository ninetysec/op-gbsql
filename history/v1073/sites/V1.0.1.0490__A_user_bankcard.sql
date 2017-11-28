-- auto gen by cherry 2017-07-27 20:57:12
DROP view IF EXISTS v_user_agent_manage;
DROP VIEW IF EXISTS v_user_player;
DROP VIEW if EXISTS v_pcenter_withdraw;
DROP VIEW IF EXISTS v_player_withdraw;

ALTER TABLE user_bankcard ALTER COLUMN bankcard_number type varchar(36);
ALTER TABLE player_withdraw ALTER COLUMN payee_bankcard TYPE varchar(36);

CREATE OR REPLACE VIEW "v_user_agent_manage" AS
 WITH ncw AS (
         SELECT notice_contact_way.user_id,
            max((
                CASE notice_contact_way.contact_type
                    WHEN '110'::text THEN notice_contact_way.contact_value
                    ELSE NULL::character varying
                END)::text) AS mobile_phone,
            max((
                CASE notice_contact_way.contact_type
                    WHEN '201'::text THEN notice_contact_way.contact_value
                    ELSE NULL::character varying
                END)::text) AS mail,
            max((
                CASE notice_contact_way.contact_type
                    WHEN '301'::text THEN notice_contact_way.contact_value
                    ELSE NULL::character varying
                END)::text) AS qq,
            max((
                CASE notice_contact_way.contact_type
                    WHEN '302'::text THEN notice_contact_way.contact_value
                    ELSE NULL::character varying
                END)::text) AS msn,
            max((
                CASE notice_contact_way.contact_type
                    WHEN '303'::text THEN notice_contact_way.contact_value
                    ELSE NULL::character varying
                END)::text) AS skype,
            max((
                CASE notice_contact_way.contact_type
                    WHEN '304'::text THEN notice_contact_way.contact_value
                    ELSE NULL::character varying
                END)::text) AS weixin
           FROM notice_contact_way
          GROUP BY notice_contact_way.user_id
        )
 SELECT ua.id,
    su.username,
    su.nation,
    su.owner_id AS topagent_id,
    tau.username AS topagent_username,
    ua.parent_id,
    psu.username AS parent_username,
    su.real_name,
    ( SELECT count(1) AS count
           FROM sys_user
          WHERE ((sys_user.owner_id = ua.id) AND ((sys_user.user_type)::text = '24'::text))) AS player_num,
    ( SELECT count(1) AS count
           FROM user_agent
          WHERE (user_agent.parent_id = ua.id)) AS agent_num,
    pr.rank_name,
    rs.name AS rebate_name,
    rsb.name AS rakeback_name,
    ''::text AS quota_name,
    ua.account_balance,
    ua.total_rebate,
    su.default_locale,
    su.default_currency,
    su.country,
    su.default_timezone,
    su.sex,
    su.birthday,
    ua.regist_code,
    ua.create_channel,
    su.create_time,
    su.register_ip,
    su.last_login_time,
        CASE
            WHEN ((su.freeze_end_time >= now()) AND (su.freeze_start_time <= now())) THEN '3'::character varying
            ELSE su.status
        END AS status,
    su.freeze_end_time,
    su.freeze_start_time,
    ua.player_rank_id,
    su.region,
    uarb.rakeback_id,
    uar.rebate_id,
    ubc.bankcard_number,
    ( SELECT array_to_string(ARRAY( SELECT t.remark_content
                   FROM remark t
                  WHERE (t.entity_user_id = su.id)), '-'::text) AS array_to_string) AS remark_content,
    su.city,
    su.built_in,
    ( SELECT count(1) AS count
           FROM user_player up,
            sys_user sur
          WHERE ((sur.owner_id = ua.id) AND (up.id = sur.id) AND (up.recharge_count > 0))) AS recharge_player_count,
    ( SELECT sum(up.recharge_total) AS sum
           FROM user_player up,
            sys_user sur
          WHERE ((sur.owner_id = ua.id) AND (up.id = sur.id) AND (up.recharge_total > (0)::numeric))) AS recharge_player_total,
    ( SELECT sum(up.withdraw_total) AS sum
           FROM user_player up,
            sys_user sur
          WHERE ((sur.owner_id = ua.id) AND (up.id = sur.id) AND (up.withdraw_total > (0)::numeric))) AS withdraw_player_total,
    ncw.mobile_phone,
    ncw.mail,
    ncw.qq,
    ncw.msn,
    ncw.skype,
    ncw.weixin
   FROM ((((((((((user_agent ua
     JOIN sys_user su ON ((((su.user_type)::text = '23'::text) AND ((su.status)::text < '5'::text) AND (ua.id = su.id))))
     LEFT JOIN ncw ON ((ua.id = ncw.user_id)))
     LEFT JOIN player_rank pr ON ((ua.player_rank_id = pr.id)))
     LEFT JOIN user_agent_rebate uar ON ((uar.user_id = su.id)))
     LEFT JOIN rebate_set rs ON ((uar.rebate_id = rs.id)))
     LEFT JOIN user_agent_rakeback uarb ON ((uarb.user_id = ua.id)))
     LEFT JOIN rakeback_set rsb ON ((uarb.rakeback_id = rsb.id)))
     LEFT JOIN user_bankcard ubc ON (((ubc.is_default = true) AND (ubc.user_id = ua.id))))
     LEFT JOIN sys_user psu ON ((ua.parent_id = psu.id)))
     LEFT JOIN sys_user tau ON ((tau.id = su.owner_id)));

CREATE OR REPLACE VIEW v_user_player AS
 SELECT a.id,
    a.rank_id,
    ((COALESCE(a.wallet_balance, (0)::numeric) + COALESCE(a.freezing_funds_balance, (0)::numeric)) + COALESCE(( SELECT sum(player_api.money) AS sum
           FROM player_api
          WHERE (player_api.player_id = a.id)), (0)::numeric)) AS total_assets,
    a.phone_code,
    a.wallet_balance,
    a.synchronization_time,
    a.special_focus,
    a.balance_type,
    a.balance_freeze_start_time,
    a.balance_freeze_end_time,
    a.freeze_code,
    a.balance_freeze_remark,
    b.account_freeze_remark,
    a.rakeback_id,
    a.level,
    a.ohter_contact_information,
    COALESCE(a.rakeback, 0.0) AS rakeback,
    COALESCE(a.backwash_total_amount, 0.0) AS backwash_total_amount,
    COALESCE(a.backwash_balance_amount, 0.0) AS backwash_balance_amount,
    a.backwash_recharge_warn,
    a.transaction_syn_time,
    COALESCE(a.recharge_count, 0) AS recharge_count,
    COALESCE(a.recharge_total, 0.0) AS recharge_total,
    COALESCE(a.recharge_max_amount, 0.0) AS recharge_max_amount,
    COALESCE(a.withdraw_count, 0) AS tx_count,
    COALESCE(a.withdraw_total, (0)::numeric) AS tx_total,
    a.level_lock,
    a.total_profit_loss,
    COALESCE(a.total_trade_volume, 0.0) AS total_trade_volume,
    COALESCE(a.total_effective_volume, 0.0) AS total_effective_volume,
    a.create_channel,
    a.mail_status,
    a.mobile_phone_status,
    a.is_first_recharge,
    COALESCE(a.manual_backwash_total_amount, 0.0) AS manual_backwash_total_amount,
    COALESCE(a.manual_backwash_balance_amount, 0.0) AS manual_backwash_balance_amount,
    b.nickname,
    b.sex,
    b.constellation,
    b.birthday,
    b.country,
    b.region,
    b.city,
    b.nation,
    b.create_time,
    a.user_agent_id,
    b.default_currency,
    b.username,
    b.password,
    b.dept_id,
    b.status,
    b.freeze_type,
    b.freeze_start_time,
    b.freeze_end_time,
    b.freeze_code AS user_freeze_code,
    b.register_ip,
    b.owner_id AS agent_id,
    a.agent_name,
    d.real_name AS agent_realname,
    a.general_agent_name,
    a.general_agent_id,
    f.real_name AS general_agent_realname,
    b.real_name,
    b.default_locale,
    ( SELECT h.username
           FROM sys_user h
          WHERE (h.id = b.create_user)) AS create_user,
    ( SELECT count(1) AS remarkcount
           FROM remark player_remark
          WHERE (player_remark.entity_user_id = a.id)) AS remarkcount,
    ( SELECT count(1) AS tagcount
           FROM player_tag
          WHERE (player_tag.player_id = a.id)) AS tagcount,
    b.default_timezone,
    r.rank_name,
    r.risk_marker,
    ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '110'::text))
         LIMIT 1) AS mobile_phone,
    ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '201'::text))
         LIMIT 1) AS mail,
    ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '301'::text))
         LIMIT 1) AS qq,
    ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '302'::text))
         LIMIT 1) AS msn,
    ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '303'::text))
         LIMIT 1) AS skype,
    ( SELECT way.status
           FROM notice_contact_way way
          WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '110'::text))
         LIMIT 1) AS mobile_phone_way_status,
    ( SELECT way.status
           FROM notice_contact_way way
          WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '201'::text))
         LIMIT 1) AS mail_way_status,
    ( SELECT way.status
           FROM notice_contact_way way
          WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '301'::text))
         LIMIT 1) AS qq_way_status,
    ( SELECT way.status
           FROM notice_contact_way way
          WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '302'::text))
         LIMIT 1) AS msn_way_status,
    ( SELECT way.status
           FROM notice_contact_way way
          WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '303'::text))
         LIMIT 1) AS skype_way_status,
    ( SELECT array_to_string(ARRAY( SELECT t.remark_content
                   FROM remark t
                  WHERE ((t.entity_user_id = a.id) OR (t.operator_id = a.id))), '-'::text) AS array_to_string) AS remarks,
    rs.name AS rakeback_name,
    ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '304'::text))
         LIMIT 1) AS weixin,
    ( SELECT way.status
           FROM notice_contact_way way
          WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '304'::text))
         LIMIT 1) AS weixin_way_status,
    b.last_login_ip,
    b.register_ip_dict_code,
    b.register_site,
    b.login_ip,
    a.regist_code,
    b.login_time,
    b.use_line,
    b.login_ip_dict_code,
    a.recommend_user_id,
    a.import_username,
    ( SELECT COALESCE(sum(pf.favorable), 0.0) AS "coalesce"
           FROM player_favorable pf
          WHERE (pf.player_id = a.id)) AS favorable_total,
    ( SELECT ub.bankcard_number
           FROM user_bankcard ub
          WHERE ((ub.user_id = a.id) AND (ub.is_default = true))
         LIMIT 1) AS bankcard_number,
    b.memo,
    b.update_user,
    b.update_time,
    gu.username AS update_username
   FROM ((((((user_player a
     JOIN sys_user b ON ((a.id = b.id)))
     LEFT JOIN sys_user d ON ((b.owner_id = d.id)))
     LEFT JOIN sys_user f ON ((d.owner_id = f.id)))
     LEFT JOIN player_rank r ON ((a.rank_id = r.id)))
     LEFT JOIN rakeback_set rs ON ((a.rakeback_id = rs.id)))
     LEFT JOIN sys_user gu ON ((b.update_user = gu.id)));

COMMENT ON VIEW v_user_player IS '玩家视图 - edit by younger';

CREATE OR REPLACE VIEW "v_pcenter_withdraw" AS
 SELECT p.id,
    p.wallet_balance,
    sys.permission_pwd,
    b.bankcard_master_name,
    b.bankcard_number,
    b.is_default,
    b.bank_name,
    r.withdraw_time_limit,
    r.withdraw_free_count,
    r.withdraw_max_fee,
    r.withdraw_fee_type,
    r.withdraw_fee_num,
    r.withdraw_check_status,
    r.withdraw_check_time,
    r.withdraw_excess_check_status,
    r.withdraw_excess_check_num,
    r.withdraw_excess_check_time,
    r.withdraw_max_num,
    r.withdraw_min_num,
    r.withdraw_count,
    r.is_withdraw_limit,
    r.status
   FROM (((user_player p
     LEFT JOIN sys_user sys ON ((sys.id = p.id)))
     LEFT JOIN user_bankcard b ON ((b.user_id = p.id)))
     LEFT JOIN player_rank r ON ((r.id = p.rank_id)))
  WHERE (b.is_default = true);


COMMENT ON VIEW "v_pcenter_withdraw" IS '玩家中心-取款视图';

CREATE OR REPLACE VIEW "v_player_withdraw" AS
 SELECT pw.id,
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
    ((pw.deduct_favorable + pw.counter_fee) + pw.administrative_fee) AS deduct_sum
   FROM ((((((((player_withdraw pw
     LEFT JOIN user_player up ON ((up.id = pw.player_id)))
     LEFT JOIN sys_user su ON ((pw.player_id = su.id)))
     LEFT JOIN sys_user ua ON ((ua.id = su.owner_id)))
     LEFT JOIN sys_user ut ON ((ut.id = ua.owner_id)))
     LEFT JOIN sys_user sul ON ((sul.id = pw.lock_person_id)))
     LEFT JOIN sys_user suc ON ((pw.check_user_id = suc.id)))
     LEFT JOIN player_transaction pt ON ((pw.player_transaction_id = pt.id)))
     LEFT JOIN player_rank pr ON ((COALESCE(pw.rank_id, up.rank_id) = pr.id)));


COMMENT ON VIEW "v_player_withdraw" IS '玩家交易表视图 edit by river重建';