-- auto gen by cherry 2016-02-28 09:35:16
 select redo_sqls($$
        ALTER TABLE "ctt_float_pic_item" ADD COLUMN "img_width" int4;
				ALTER TABLE "ctt_float_pic_item" ADD COLUMN "img_height" int4;
      $$);

COMMENT ON COLUMN "ctt_float_pic_item"."img_width" IS '图片宽度';
COMMENT ON COLUMN "ctt_float_pic_item"."img_height" IS '图片高度';

DROP VIEW IF EXISTS v_ctt_logo_user;
CREATE OR REPLACE VIEW "v_ctt_logo_user" AS
 SELECT a.id,
    a.name,
    a.start_time,
    a.end_time,
    a.create_user,
    a.create_time,
    a.update_user,
    a.update_time,
        CASE
            WHEN (( SELECT count(1) AS count
               FROM ctt_logo l
              WHERE (l.check_parent_id = a.id)) = 1) THEN ( SELECT l.publish_time
               FROM ctt_logo l
              WHERE (l.check_parent_id = a.id))
            ELSE a.publish_time
        END AS publish_time,
    a.is_default,
    a.check_user_id,
    a.check_time,
    a.reason_title,
    a.reason_content,
    a.author,
    b.user_type,
    b.username,
    a.is_delete,
    a.check_parent_id,
        CASE
            WHEN (( SELECT count(1) AS count
               FROM ctt_logo l
              WHERE (l.check_parent_id = a.id)) = 1) THEN ( SELECT l.check_status
               FROM ctt_logo l
              WHERE (l.check_parent_id = a.id))
            ELSE a.check_status
        END AS check_status,
        CASE
            WHEN (( SELECT count(1) AS count
               FROM ctt_logo l
              WHERE (l.check_parent_id = a.id)) > 0) THEN ( SELECT l.path
               FROM ctt_logo l
              WHERE (l.check_parent_id = a.id))
            ELSE a.path
        END AS path
   FROM (( SELECT l.id,
            l.name,
            l.path,
            l.start_time,
            l.end_time,
            l.create_user,
            l.create_time,
            l.update_user,
            l.update_time,
            l.publish_time,
            l.is_default,
            l.check_user_id,
            l.check_status,
            l.check_time,
            l.reason_title,
            l.reason_content,
            l.is_delete,
            l.check_parent_id,
            COALESCE(l.update_user, l.create_user) AS author
           FROM ctt_logo l) a
     LEFT JOIN sys_user b ON ((a.author = b.id)))
  WHERE ((a.is_delete = false) AND (a.check_parent_id IS NULL));

COMMENT ON VIEW "v_ctt_logo_user" IS 'LOGO提交审核人信息--river';