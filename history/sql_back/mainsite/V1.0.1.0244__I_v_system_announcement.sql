-- auto gen by orange 2016-01-20 16:01:17
DROP VIEW IF EXISTS v_system_announcement;

select redo_sqls($$
  ALTER TABLE "system_announcement_i18n"
  ALTER COLUMN "title" TYPE varchar(200) COLLATE "default",
  ALTER COLUMN "content" TYPE varchar(3000) COLLATE "default";
$$);

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
    s.timing_send,
    s.announcement_subtype,
    s.site_id
   FROM (system_announcement s
     LEFT JOIN system_announcement_i18n a ON ((a.system_announcement_id = s.id)));

ALTER TABLE "v_system_announcement" OWNER TO "postgres";

COMMENT ON VIEW "v_system_announcement" IS '系统公告视图 - Orange';
