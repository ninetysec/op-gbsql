-- auto gen by cheery 2015-12-10 09:48:46
DROP VIEW IF EXISTS v_game_announcement;
DROP TABLE IF EXISTS game_announcement;
DROP TABLE IF EXISTS game_announcement_i18n;
DROP VIEW IF EXISTS v_system_announcement;

select redo_sqls($$
   ALTER TABLE "system_announcement" ADD COLUMN "game_id" int4;
  ALTER TABLE "system_announcement" ADD COLUMN "timing_send" bool;
$$);

COMMENT ON COLUMN "system_announcement"."game_id" IS '游戏id';
COMMENT ON COLUMN "system_announcement"."timing_send" IS '是否定时发送';

CREATE OR REPLACE VIEW "v_system_announcement" AS
 SELECT s.id,
    s.release_mode,
    s.publish_time,
    s.publish_user_id,
    a.local,
    a.title,
    a.content,
    s.announcement_type,
    s.publish_platform,
    s.publish_user_name,
    s.operate_time,
    s.api_id,
    s.game_id,
    s.center_id,
    s.timing_send
   FROM (system_announcement s
     LEFT JOIN system_announcement_i18n a ON ((a.system_announcement_id = s.id)));

ALTER TABLE "v_system_announcement" OWNER TO "postgres";

COMMENT ON VIEW "v_system_announcement" IS '系统公告视图 - Orange';