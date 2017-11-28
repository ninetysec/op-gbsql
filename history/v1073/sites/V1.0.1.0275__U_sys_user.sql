-- auto gen by bruce 2016-10-04 17:34:28
select redo_sqls($$
  ALTER TABLE sys_user ADD COLUMN terminal VARCHAR(1);
$$);
COMMENT ON COLUMN "sys_user"."terminal" IS '登录终端：1-PC，2-MOBILE';

DROP VIEW IF EXISTS v_player_online;
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
        gameids.string_agg AS gameids,
        s.session_key,
        u.wallet_balance,
        u.freezing_funds_balance,
        s.terminal
   FROM ((user_player u
   JOIN sys_user s ON ((s.id = u.id)))
   LEFT JOIN (SELECT string_agg(((player_game_log.game_id)::character varying)::text, ','::text) AS string_agg,
                     player_game_log.session_key,
                     player_game_log.user_id
                FROM player_game_log
               WHERE (player_game_log.session_key IS NOT NULL)
               GROUP BY player_game_log.session_key, player_game_log.user_id) gameids ON (((gameids.user_id = u.id) AND ((gameids.session_key)::text = (s.session_key)::text))))
  WHERE (s.session_key IS NOT NULL);

COMMENT ON VIEW v_player_online IS '在线玩家视图--susu';