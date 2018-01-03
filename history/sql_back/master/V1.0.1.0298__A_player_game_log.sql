-- auto gen by cheery 2015-12-30 10:56:32
select redo_sqls($$
 ALTER TABLE "player_game_log" ADD COLUMN "online_session_id" int4;
$$);

DROP INDEX IF EXISTS fk_player_game_order_player_id;
CREATE INDEX "fk_player_game_order_player_id" ON "player_game_order" USING btree (player_id);

drop view IF EXISTS v_player_online1;

drop view IF EXISTS v_player_online;

CREATE OR REPLACE VIEW v_player_online AS
 SELECT s.id,
    s.username,
    s.real_name,
    s.login_time,
    s.login_ip,
    s.last_active_time,
    s.use_line,
    s.last_login_time,
    s.last_login_ip,
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

drop table IF EXISTS sys_player_game_log;

drop view IF EXISTS v_user_master;
drop table IF EXISTS user_master;
