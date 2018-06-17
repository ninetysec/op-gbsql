-- auto gen by cherry 2018-05-26 16:20:24
DROP VIEW IF EXISTS v_player_online;
DROP VIEW IF EXISTS v_user_player;
DROP VIEW IF EXISTS v_top_agent_player;
DROP VIEW IF EXISTS v_agent_player;
ALTER TABLE user_player ALTER COLUMN create_channel type varchar(2);

CREATE OR REPLACE VIEW "v_player_online" AS
 SELECT s.id,
    s.username,
    s.real_name,
    s.login_time,
    s.login_ip,
    s.login_ip_dict_code,
    s.last_active_time,
    s.use_line,
    s.last_login_time,
    s.last_login_ip,
    s.last_login_ip_dict_code,
    s.total_online_time,
    string_agg(((pgl.game_id)::character varying)::text, ','::text) AS gameids,
    string_agg(((pgl.api_id)::character varying)::text, ','::text) AS apiids,
    s.session_key,
    u.wallet_balance,
    u.freezing_funds_balance,
    u.rank_id,
    u.create_channel AS channel_terminal,
    s.terminal,
    u.user_agent_id,
    ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE ((way.user_id = s.id) AND ((way.contact_type)::text = '110'::text))
         LIMIT 1) AS mobile_phone,
    ( SELECT way.status
           FROM notice_contact_way way
          WHERE ((way.user_id = s.id) AND ((way.contact_type)::text = '110'::text))
         LIMIT 1) AS mobile_phone_way_status
   FROM ((user_player u
     JOIN sys_user s ON ((s.id = u.id)))
     LEFT JOIN player_game_log pgl ON (((pgl.user_id = s.id) AND ((pgl.session_key)::text = (s.session_key)::text))))
  WHERE ((s.session_key IS NOT NULL) AND ((s.login_time > s.last_logout_time) OR (s.last_logout_time IS NULL)) AND (s.last_active_time > (now() - '00:30:00'::interval)))
  GROUP BY s.id, s.username, s.real_name, s.login_time, s.login_ip, s.login_ip_dict_code, s.last_active_time, s.use_line, s.last_login_time, s.last_login_ip, s.last_login_ip_dict_code, s.total_online_time, s.session_key, u.wallet_balance, u.freezing_funds_balance, u.rank_id, u.create_channel, s.terminal, u.user_agent_id;

COMMENT ON VIEW "v_player_online" IS '在线玩家视图 edit by linsen -younger-steffan';

CREATE OR REPLACE VIEW "v_user_player" AS
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

COMMENT ON VIEW "v_user_player" IS '玩家视图 - edit by steffan';

CREATE OR REPLACE VIEW "v_top_agent_player" AS
 SELECT su.id,
    su.owner_id,
    ua.parent_id,
    up.create_channel,
    su.username,
    su.create_time,
    su.last_login_time,
    su.status,
    su.freeze_start_time,
    su.freeze_end_time,
    up.balance_freeze_start_time,
    up.balance_freeze_end_time
   FROM ((sys_user su
     JOIN user_player up ON ((su.id = up.id)))
     JOIN user_agent ua ON ((su.owner_id = ua.id)))
  WHERE ((su.status)::text <> ALL (ARRAY[('4'::character varying)::text, ('5'::character varying)::text]))
  ORDER BY su.create_time DESC;

COMMENT ON VIEW "v_top_agent_player" IS '总代下玩家视图 - Fly';

CREATE OR REPLACE VIEW "v_agent_player" AS
 SELECT su.id,
    su.owner_id,
    up.create_channel,
    su.username,
    su.create_time,
    su.last_login_time,
    su.status,
    su.freeze_start_time,
    su.freeze_end_time,
    up.balance_freeze_start_time,
    up.balance_freeze_end_time
   FROM (sys_user su
     JOIN user_player up ON ((su.id = up.id)))
  WHERE (((su.status)::text <> ALL (ARRAY[('4'::character varying)::text, ('5'::character varying)::text])) AND ((su.user_type)::text = '24'::text))
  ORDER BY su.create_time DESC;


COMMENT ON VIEW "v_agent_player" IS '代理下玩家视图 - Fly';