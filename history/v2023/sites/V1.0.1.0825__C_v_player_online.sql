-- auto gen by steffan 2018-05-18 14:19:50
-- 在线玩家视图修改，来源终端使用user_player的create_terminal
drop view if exists v_player_online;
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
    u.create_channel channel_terminal,
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