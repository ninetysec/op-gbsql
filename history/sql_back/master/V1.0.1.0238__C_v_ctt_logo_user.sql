-- auto gen by cheery 2015-11-27 15:45:35
DROP VIEW IF EXISTS v_ctt_logo_user;
CREATE OR REPLACE VIEW v_ctt_logo_user AS
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
    b.username
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
           COALESCE(l.update_user, l.create_user) AS author
         FROM ctt_logo l) a,
    sys_user b
  WHERE a.author = b.id;
COMMENT ON VIEW v_ctt_logo_user  IS 'LOGO提交审核人信息';


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
    b.username
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
           COALESCE(l.update_user_id, l.create_user_id) AS author
         FROM ctt_document l) a,
    sys_user b
  WHERE a.author = b.id;
COMMENT ON VIEW v_ctt_document_user  IS '文案提交审核人信息';


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
         FROM activity_message l) a,
    sys_user b
  WHERE a.author = b.id;
COMMENT ON VIEW v_activity_message_user  IS '文案提交审核人信息';

