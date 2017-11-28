-- auto gen by cherry 2016-02-02 16:53:16
DROP VIEW IF EXISTS v_activity_message_user;
CREATE OR REPLACE VIEW v_activity_message_user AS
 SELECT a.id,
    a.start_time,
    a.end_time,
    a.activity_state,
    a.create_time,
    a.user_id,
    a.user_name,
    a.activity_classify_key,
    a.activity_type_code,
    a.is_display,
    a.is_deleted,
    a.update_user_id,
    a.update_time,
    a.check_user_id,
    a.check_status,
    a.check_time,
    a.reason_title,
    a.reason_content,
    a.author,
    b.user_type,
    b.username
   FROM ( SELECT l.id,
            l.start_time,
            l.end_time,
            l.activity_state,
            l.create_time,
            l.user_id,
            l.user_name,
            l.activity_classify_key,
            l.activity_type_code,
            l.is_display,
            l.is_deleted,
            l.update_user_id,
            l.update_time,
            l.check_user_id,
            l.check_status,
            l.check_time,
            l.reason_title,
            l.reason_content,
            COALESCE(l.update_user_id, l.user_id) AS author
           FROM activity_message l) a
     LEFT JOIN sys_user b ON a.author = b.id;

COMMENT ON VIEW v_activity_message_user IS '优惠活动信息视图 river';

DROP VIEW IF EXISTS v_ctt_document_user;

CREATE OR REPLACE VIEW v_ctt_document_user AS
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
           FROM ctt_document l) a
     LEFT JOIN sys_user b ON a.author = b.id;

COMMENT ON VIEW v_ctt_document_user IS '文案提交审核人信息 river';

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
           FROM ctt_logo l) a
     LEFT JOIN sys_user b ON a.author = b.id
  WHERE a.is_delete = false AND a.check_parent_id IS NULL;

COMMENT ON VIEW v_ctt_logo_user IS 'LOGO提交审核人信息';

UPDATE sys_user SET user_type = '2' where id = 0 ;