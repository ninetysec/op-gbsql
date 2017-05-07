-- auto gen by orange 2015-12-27 09:53:28
DROP VIEW IF EXISTS v_notice_received_text;

DROP TABLE IF EXISTS station_letter_sign;

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
    t.content
   FROM notice_receive r
     LEFT JOIN notice_send s ON r.send_id = s.id
     LEFT JOIN notice_text t ON s.text_id = t.id;

ALTER TABLE "v_notice_received_text" OWNER TO "postgres";

COMMENT ON VIEW "v_notice_received_text" IS '站内信视图--orange';