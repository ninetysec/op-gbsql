-- auto gen by cherry 2016-01-17 09:24:00
 select redo_sqls($$
    ALTER TABLE "ctt_document" ADD COLUMN "is_delete" bool;
ALTER TABLE "ctt_logo" ADD COLUMN "is_delete" bool;
ALTER TABLE "ctt_logo" ADD COLUMN "check_parent_id" int4;
      $$);

COMMENT ON COLUMN "ctt_document"."is_delete" IS '是否删除';
COMMENT ON COLUMN "ctt_logo"."is_delete" IS '是否删除';
COMMENT ON COLUMN "ctt_logo"."check_parent_id" IS '审核父项ID';

DROP VIEW IF EXISTS v_ctt_document;
CREATE OR REPLACE VIEW "v_ctt_document" AS
 SELECT t.id,
    t.parent_id,
    t.create_user_id,
    t.create_time,
    t.build_in,
    t.status,
    t.update_user_id,
    t.update_time,
    t.check_user_id,
    t.check_status,
    t.check_time,
    t.publish_time,
    ( SELECT count(1) AS languagecount
           FROM ctt_document_i18n a
          WHERE (a.document_id = t.id)) AS language_count,
    ( SELECT count(1) AS childcount
           FROM ctt_document b_1
          WHERE (b_1.parent_id = t.id)) AS child_count,
    t.code,
    t.order_num,
    t.is_delete
   FROM ctt_document t
  ORDER BY t.build_in DESC;
COMMENT ON VIEW "v_ctt_document" IS '文案信息视图 add by river';

DROP VIEW IF EXISTS v_ctt_document_user;
CREATE OR REPLACE VIEW "v_ctt_document_user" AS
 SELECT a.id,
    a.parent_id,
    a.create_user_id,
    a.create_time,
    a.build_in,
    a.status,
    a.update_user_id,
    a.update_time,
    a.check_user_id,
    a.check_status,
    a.check_time,
    a.publish_time,
    a.reason_title,
    a.reason_content,
    a.author,
    b.user_type,
    b.username,
   a.is_delete
   FROM ( SELECT l.id,
            l.parent_id,
            l.create_user_id,
            l.create_time,
            l.build_in,
            l.status,
            l.update_user_id,
            l.update_time,
            l.check_user_id,
            l.check_status,
            l.check_time,
            l.publish_time,
            l.reason_title,
            l.reason_content,
            l.is_delete,
            COALESCE(l.update_user_id, l.create_user_id) AS author
           FROM ctt_document l) a,
    sys_user b
  WHERE (a.author = b.id);
COMMENT ON VIEW "v_ctt_document_user" IS '文案提交审核人信息';

DROP VIEW IF EXISTS v_ctt_logo_user;
CREATE OR REPLACE VIEW "v_ctt_logo_user" AS
 SELECT a.id,
    a.name,
    a.path,
    a.start_time,
    a.end_time,
    a.create_user,
    a.create_time,
    a.update_user,
    a.update_time,
    a.publish_time,
    a.is_default,
    a.check_user_id,
    a.check_status,
    a.check_time,
    a.reason_title,
    a.reason_content,
    a.author,
    b.user_type,
    b.username,
    a.is_delete,
		a.check_parent_id
   FROM ( SELECT l.id,
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
           FROM ctt_logo l) a,
    sys_user b
  WHERE (a.author = b.id);
COMMENT ON VIEW "v_ctt_logo_user" IS 'LOGO提交审核人信息';