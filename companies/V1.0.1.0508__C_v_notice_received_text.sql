-- auto gen by cherry 2018-01-05 11:30:21
DROP VIEW IF EXISTS v_notice_received_text;
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
     LEFT JOIN notice_text t ON ((s.text_id = t.id)));

COMMENT ON VIEW "v_notice_received_text" IS '站内信视图--orange';

DROP VIEW IF EXISTS v_sys_role;
CREATE OR REPLACE VIEW "v_sys_role" AS
 SELECT sr.id,
    sr.name,
    sr.site_id,
    sr.subsys_code,
    sr.built_in,
		sr.create_user,
    COALESCE(user_role.user_count, (0)::bigint) AS user_count
   FROM (sys_role sr
     LEFT JOIN ( SELECT sys_user_role.role_id,
            count(1) AS user_count
           FROM sys_user_role
          GROUP BY sys_user_role.role_id) user_role ON ((user_role.role_id = sr.id)));



