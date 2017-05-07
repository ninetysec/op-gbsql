-- auto gen by tony 2016-01-14 10:33:32
ALTER TABLE "sys_on_line_session" DROP COLUMN IF EXISTS "client_ip_dict_code";

DROP VIEW v_player_online;

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
    ( SELECT string_agg(player_game_log.game_id::character varying::text, ','::text) AS string_agg
           FROM player_game_log
          WHERE player_game_log.online_session_id = o.id) AS gameids
   FROM sys_on_line_session o
     JOIN user_player u ON o.sys_user_id = u.id
     LEFT JOIN sys_user s ON s.id = u.id;

ALTER TABLE v_player_online
  OWNER TO postgres;
COMMENT ON VIEW v_player_online
  IS '在线玩家视图--susu';