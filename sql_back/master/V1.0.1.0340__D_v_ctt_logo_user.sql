-- auto gen by cherry 2016-01-20 09:23:33
DROP VIEW IF EXISTS v_ctt_logo_user;
CREATE OR REPLACE VIEW v_ctt_logo_user AS
 SELECT a.id,
    a.name,
    a.start_time,
    a.end_time,
    a.create_user,
    a.create_time,
    a.update_user,
    a.update_time,
    a.publish_time,
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
              WHERE l.check_parent_id = a.id)) = 1 THEN ( SELECT l.check_status
               FROM ctt_logo l
              WHERE l.check_parent_id = a.id)
            ELSE a.check_status
        END AS check_status,
        CASE
            WHEN (( SELECT count(1) AS count
               FROM ctt_logo l
              WHERE l.check_parent_id = a.id)) > 0 THEN ( SELECT l.path
               FROM ctt_logo l
              WHERE l.check_parent_id = a.id)
            ELSE a.path
        END AS path
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
  WHERE a.author = b.id AND a.is_delete = false AND a.check_parent_id IS NULL;

COMMENT ON VIEW v_ctt_logo_user IS 'LOGO提交审核人信息';

DROP VIEW IF EXISTS v_ctt_document;
CREATE OR REPLACE VIEW v_ctt_document AS
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
          WHERE a.document_id = t.id) AS language_count,
    ( SELECT count(1) AS childcount
           FROM ctt_document b_1
          WHERE b_1.parent_id = t.id AND b_1.is_delete = false) AS child_count,
    t.code,
    t.order_num,
    t.is_delete
   FROM ctt_document t
  ORDER BY t.build_in DESC;

COMMENT ON VIEW v_ctt_document IS '文案信息视图 add by river';



