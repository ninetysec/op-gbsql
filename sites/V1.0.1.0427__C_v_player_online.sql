-- auto gen by cherry 2017-04-20 21:18:39
CREATE INDEX if not EXISTS idx_player_favorable_player_id ON player_favorable(player_id);

DROP VIEW if EXISTS v_player_online;
CREATE OR REPLACE VIEW v_player_online AS
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
    string_agg(pgl.game_id::character varying::text, ','::text) AS gameids,
    s.session_key,
    u.wallet_balance,
    u.freezing_funds_balance,
    s.terminal
   FROM user_player u
     JOIN sys_user s ON s.id = u.id
     LEFT JOIN player_game_log pgl ON pgl.user_id = s.id AND pgl.session_key = s.session_key
  WHERE s.session_key IS NOT NULL
  GROUP BY s.id,
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
        s.session_key,
        u.wallet_balance,
        u.freezing_funds_balance,
        s.terminal
;