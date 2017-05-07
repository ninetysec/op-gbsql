-- auto gen by tony 2016-06-05 15:54:46
  select redo_sqls($$
    ALTER TABLE player_game_log ADD COLUMN session_key character varying(40);
  $$);
  select redo_sqls($$
      COMMENT ON COLUMN player_game_log.session_key IS '玩家的session_key,online_session_id将被删除';
  $$);
  select redo_sqls($$
    ALTER TABLE sys_user ADD COLUMN session_key character varying(40);
  $$);
  select redo_sqls($$
      COMMENT ON COLUMN sys_user.session_key IS '用户的session_key,online_session_id将被删除';
  $$);
DROP  VIEW if exists v_player_online;

CREATE VIEW v_player_online AS
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
    gameids.string_agg gameids,
    s.session_key
   FROM user_player u
     INNER JOIN sys_user s ON s.id = u.id
     LEFT JOIN (SELECT string_agg(player_game_log.game_id::character varying::text, ','::text) AS string_agg,
                       session_key,user_id
                FROM player_game_log  where session_key is not null
          GROUP BY session_key,user_id) as gameids
          ON  gameids.user_id = u.id and gameids.session_key = s.session_key
     where s.session_key is not null;

COMMENT ON VIEW v_player_online  IS '在线玩家视图--susu';

DROP VIEW if exists v_user_top_agent_manage;

CREATE OR REPLACE VIEW v_user_top_agent_manage AS
 SELECT ua.id,
    su.username,
    su.nation,
    su.real_name,
    ( SELECT count(1) AS count
           FROM sys_user child
          WHERE child.owner_id = ua.id AND child.user_type::text = '23'::text) AS child_agent_num,
    ( SELECT count(1) AS count
           FROM user_player players
           INNER JOIN sys_user _user on players.id=_user.id
          WHERE (players.user_agent_id IN ( SELECT child.id
                   FROM sys_user child
                  WHERE child.owner_id = ua.id))) AS player_num,
    ( SELECT count(1) AS count
           FROM rebate_set rs
             JOIN user_agent_rebate uar ON uar.rebate_id = rs.id
          WHERE uar.user_id = su.id) AS rebatenum,
    ( SELECT count(1) AS count
           FROM rakeback_set rs
             JOIN user_agent_rakeback uarb ON uarb.rakeback_id = rs.id
          WHERE uarb.user_id = su.id) AS rakebacknum,
    su.default_locale,
    su.country,
    su.default_timezone,
    ctct.mobile_phone,
    ctct.mail,
    su.sex,
    su.birthday,
    ua.regist_code,
    ua.create_channel,
    su.create_time,
    su.register_ip,
    su.last_login_time,
    ctct.qq,
    ctct.msn,
    ctct.skype,
        CASE
            WHEN su.freeze_end_time >= now() AND su.freeze_start_time <= now() THEN '3'::character varying(5)
            ELSE su.status
        END AS status,
    su.freeze_end_time,
    su.freeze_start_time,
    su.region,
    su.constellation,
    ( SELECT array_to_string(ARRAY( SELECT t.remark_content
                   FROM remark t
                  WHERE t.entity_user_id = su.id), '-'::text) AS array_to_string) AS remark_content
   FROM user_agent ua
     JOIN ( SELECT sys_user.id,
            sys_user.username,
            sys_user.password,
            sys_user.dept_id,
            sys_user.status,
            sys_user.create_user,
            sys_user.create_time,
            sys_user.update_user,
            sys_user.update_time,
            sys_user.default_locale,
            sys_user.default_timezone,
            sys_user.subsys_code,
            sys_user.user_type,
            sys_user.built_in,
            sys_user.site_id,
            sys_user.owner_id,
            sys_user.freeze_type,
            sys_user.freeze_start_time,
            sys_user.freeze_end_time,
            sys_user.freeze_code,
            sys_user.login_time,
            sys_user.login_ip,
            sys_user.last_active_time,
            sys_user.use_line,
            sys_user.last_login_time,
            sys_user.last_login_ip,
            sys_user.total_online_time,
            sys_user.nickname,
            sys_user.real_name,
            sys_user.birthday,
            sys_user.sex,
            sys_user.constellation,
            sys_user.country,
            sys_user.nation,
            sys_user.register_ip,
            sys_user.avatar_url,
            sys_user.permission_pwd,
            sys_user.idcard,
            sys_user.default_currency,
            sys_user.register_site,
            sys_user.region,
            sys_user.city,
            sys_user.memo
           FROM sys_user
          WHERE sys_user.user_type::text = '22'::text AND sys_user.status::text < '5'::text) su ON ua.id = su.id
     LEFT JOIN ( SELECT ct.user_id,
            ct.mobile_phone,
            ct.mail,
            ct.qq,
            ct.msn,
            ct.skype
           FROM crosstab('SELECT user_id, contact_type,contact_value

	       FROM   notice_contact_way

	       ORDER  BY user_id,contact_type'::text, 'VALUES (''110''::text),  (''201''::text),  (''301''::text), (''302''::text), (''303''::text)'::text) ct(user_id integer, mobile_phone character varying, mail character varying, qq character varying, msn character varying, skype character varying)) ctct ON ua.id = ctct.user_id;

DROP VIEW if exists v_user_player;

CREATE OR REPLACE VIEW v_user_player AS
 SELECT a.id,
    a.rank_id,
    a.total_assets,
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
    a.rakeback,
    a.backwash_total_amount,
    a.backwash_balance_amount,
    a.backwash_recharge_warn,
    a.transaction_syn_time,
    a.recharge_count,
    a.recharge_total,
    a.recharge_max_amount,
    a.withdraw_count AS tx_count,
    a.withdraw_total AS tx_total,
    a.level_lock,
    a.total_profit_loss,
    a.total_trade_volume,
    a.total_effective_volume,
    a.create_channel,
    a.mail_status,
    a.mobile_phone_status,
    a.is_first_recharge,
    a.manual_backwash_total_amount,
    a.manual_backwash_balance_amount,
    b.nickname,
    b.sex,
    b.constellation,
    b.birthday,
    b.country,
    b.region,
    b.city,
    b.nation,
    b.create_time,
    b.owner_id AS user_agent_id,
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
    d.username AS agent_name,
    d.real_name AS agent_realname,
    f.username AS general_agent_name,
    f.id AS general_agent_id,
    f.real_name AS general_agent_realname,
    b.real_name,
    b.default_locale,
    ( SELECT h.username
           FROM sys_user h
          WHERE h.id = b.create_user) AS create_user,
    ( SELECT count(1) AS remarkcount
           FROM remark player_remark
          WHERE player_remark.entity_user_id = a.id) AS remarkcount,
    ( SELECT count(1) AS tagcount
           FROM player_tag
          WHERE player_tag.player_id = a.id) AS tagcount,
    b.default_timezone,
    r.rank_name,
    r.risk_marker,
    ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE way.user_id = a.id AND way.contact_type::text = '110'::text
         LIMIT 1) AS mobile_phone,
    ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE way.user_id = a.id AND way.contact_type::text = '201'::text
         LIMIT 1) AS mail,
    ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE way.user_id = a.id AND way.contact_type::text = '301'::text
         LIMIT 1) AS qq,
    ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE way.user_id = a.id AND way.contact_type::text = '302'::text
         LIMIT 1) AS msn,
    ( SELECT way.contact_value
           FROM notice_contact_way way
          WHERE way.user_id = a.id AND way.contact_type::text = '303'::text
         LIMIT 1) AS skype,
    ( SELECT way.status
           FROM notice_contact_way way
          WHERE way.user_id = a.id AND way.contact_type::text = '110'::text
         LIMIT 1) AS mobile_phone_way_status,
    ( SELECT way.status
           FROM notice_contact_way way
          WHERE way.user_id = a.id AND way.contact_type::text = '201'::text
         LIMIT 1) AS mail_way_status,
    ( SELECT way.status
           FROM notice_contact_way way
          WHERE way.user_id = a.id AND way.contact_type::text = '301'::text
         LIMIT 1) AS qq_way_status,
    ( SELECT way.status
           FROM notice_contact_way way
          WHERE way.user_id = a.id AND way.contact_type::text = '302'::text
         LIMIT 1) AS msn_way_status,
    ( SELECT way.status
           FROM notice_contact_way way
          WHERE way.user_id = a.id AND way.contact_type::text = '303'::text
         LIMIT 1) AS skype_way_status,
    ( SELECT array_to_string(ARRAY( SELECT t.remark_content
                   FROM remark t
                  WHERE t.entity_user_id = a.id OR t.operator_id = a.id), '-'::text) AS array_to_string) AS remarks,
    rs.name AS rakeback_name
   FROM user_player a
     JOIN sys_user b ON a.id = b.id
     LEFT JOIN sys_user d ON b.owner_id = d.id
     LEFT JOIN sys_user f ON d.owner_id = f.id
     LEFT JOIN player_rank r ON a.rank_id = r.id
     LEFT JOIN rakeback_set rs ON a.rakeback_id = rs.id;


DROP VIEW if exists v_sys_user_player_frozen;

CREATE OR REPLACE VIEW v_sys_user_player_frozen AS
 SELECT _user.id,
    _user.username,
    _user.status,
    _user.site_id,
    _user.freeze_type,
    _user.account_freeze_remark,
    _user.freeze_start_time,
    _user.freeze_end_time,
    _player.balance_type,
    _player.balance_freeze_start_time,
    _player.balance_freeze_end_time,
    _player.balance_freeze_remark,
    _player.id AS player_id,
    _user.default_locale,
    _user.freeze_title,
    _user.freeze_content,
    _player.balance_freeze_title,
    _player.balance_freeze_content,
    _player.balance_freeze_user_id,
    _user.freeze_user,
    _user.disabled_user,
    _user.disabled_time,
    _user.freeze_time
   FROM sys_user _user
     LEFT JOIN user_player _player ON _user.id = _player.id;

COMMENT ON VIEW v_sys_user_player_frozen
  IS '玩家账号冻结--tom';





