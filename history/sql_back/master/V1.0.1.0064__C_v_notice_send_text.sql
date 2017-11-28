-- auto gen by kevice 2015-09-11 09:25:34

DROP VIEW IF EXISTS v_notice_send_text;
CREATE OR REPLACE VIEW v_notice_send_text AS
 SELECT s.id, s.publish_method, s.comet_subscribe_type,
    s.remind_method, s.locale, s.orig_send_id, s.status, s.receiver_group_type, s.receiver_group_id, s.update_time as send_time, s.timing,
    t.title, t.content, t.create_user, t.create_username, t.create_time
   FROM notice_send s LEFT JOIN notice_text t ON s.text_id = t.id;
COMMENT ON VIEW v_notice_send_text
  IS '发送的通知信息';