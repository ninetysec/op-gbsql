-- auto gen by orange 2016-03-21 09:21:05
-- 添加或修改字段注释
COMMENT ON COLUMN system_announcement.site_id IS '接收站点id(为空即为下级所有站点)';

-- 添加字段, 为test表添加字段name
  select redo_sqls($$
    ALTER TABLE system_announcement ADD COLUMN publish_site_id int4;
    COMMENT ON COLUMN "system_announcement"."publish_site_id" IS '总控或运营商ID';
  $$);

DROP VIEW IF EXISTS v_system_announcement;

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
    s.site_id,
    s.publish_site_id
   FROM (system_announcement s
     LEFT JOIN system_announcement_i18n a ON ((a.system_announcement_id = s.id)));

ALTER TABLE "v_system_announcement" OWNER TO "postgres";

COMMENT ON VIEW "v_system_announcement" IS '系统公告视图 - Orange';

