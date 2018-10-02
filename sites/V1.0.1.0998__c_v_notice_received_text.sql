-- auto gen by younger 2018-10-01 22:04:53
CREATE OR REPLACE VIEW "v_notice_received_text" AS
 SELECT r.id,
    r.receiver_id,
    r.status AS receive_status,
    r.create_time AS receive_time,
    s.publish_method,
    s.comet_subscribe_type,
    s.remind_method,
    s.locale,
    s.orig_send_id,
    t.title,
    t.content,
    t.create_user,
    t.create_username
   FROM ((notice_receive r
     LEFT JOIN notice_send s ON ((r.send_id = s.id)))
     LEFT JOIN notice_text t ON ((s.text_id = t.id))) where t.create_time is not null;

COMMENT ON VIEW "v_notice_received_text" IS '站内信视图--orange -edit by younger';