-- auto gen by admin 2016-06-14 14:42:19
 select redo_sqls($$
      ALTER TABLE activity_rule ADD COLUMN deposit_way character varying(255);

      $$);

COMMENT ON COLUMN activity_rule.deposit_way IS '存款方式';

DROP VIEW IF EXISTS v_player_online;
ALTER TABLE player_game_log ALTER COLUMN session_key type varchar(64);

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
    gameids.string_agg,
    gameids.session_key
   FROM (( user_player u
     LEFT JOIN sys_user s ON ((s.id = u.id)))
     LEFT JOIN ( SELECT string_agg(((player_game_log.game_id)::character varying)::text, ','::text) AS string_agg,
            player_game_log.session_key,
            player_game_log.user_id
           FROM player_game_log
          GROUP BY player_game_log.session_key, player_game_log.user_id) gameids ON ((gameids.user_id = u.id)));

COMMENT ON VIEW  "v_player_online" IS '在线玩家视图--susu';