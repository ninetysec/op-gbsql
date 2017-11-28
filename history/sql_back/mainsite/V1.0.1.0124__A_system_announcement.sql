-- auto gen by cheery 2015-11-27 15:44:57
select redo_sqls($$
   ALTER TABLE "system_announcement" ADD COLUMN "announcement_type" varchar(32),ADD COLUMN "publish_platform" varchar(32);
$$);

COMMENT ON COLUMN "system_announcement"."announcement_type" IS '公告类型operation.announcement_type(系统公告,运营公告)';

COMMENT ON COLUMN "system_announcement"."publish_platform" IS '发布平台operation.publish_platform(总控,运营商)';

DROP VIEW IF EXISTS v_system_announcement;

CREATE OR REPLACE VIEW "v_system_announcement" AS
SELECT s.id,
  s.release_mode,
  s.publish_time,
  s.publish_user_id,
  a.local,
  a.title,
  a.content,
  u.username,
  s.announcement_type,
  s.publish_platform
FROM system_announcement s
  LEFT JOIN system_announcement_i18n a ON a.system_announcement_id = s.id
  LEFT JOIN sys_user u ON u.id = s.publish_user_id;

ALTER TABLE "v_system_announcement" OWNER TO "postgres";

COMMENT ON VIEW "v_system_announcement" IS '系统公告视图 --orange';