-- auto gen by linsen 2018-04-27 20:46:26
-- 修改视图：新增玩家最后登录时间字段 by linsen

DROP VIEW IF EXISTS v_user_player;
CREATE OR REPLACE VIEW  "v_user_player" AS
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
    b.site_id,
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
    b.last_login_ip_dict_code,
    b.register_ip_dict_code,
    b.register_site,
    b.login_ip,
    a.regist_code,
    b.login_time,
    b.last_login_time,
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
    gu.username AS update_username,
    (((b.login_time > b.last_logout_time) OR (b.last_logout_time IS NULL)) AND (b.last_active_time > (now() - '00:30:00'::interval))) AS on_line,
    a.risk_data_type,
    a.deposit_send_type,
    a.deposit_send_start_time
   FROM ((((((user_player a
     JOIN sys_user b ON ((a.id = b.id)))
     LEFT JOIN sys_user d ON ((b.owner_id = d.id)))
     LEFT JOIN sys_user f ON ((d.owner_id = f.id)))
     LEFT JOIN player_rank r ON ((a.rank_id = r.id)))
     LEFT JOIN rakeback_set rs ON ((a.rakeback_id = rs.id)))
     LEFT JOIN sys_user gu ON ((b.update_user = gu.id)));

COMMENT ON VIEW  "v_user_player" IS '玩家视图 - edit by steffan';