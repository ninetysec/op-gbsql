-- auto gen by cheery 2015-12-23 17:35:52

Drop view if EXISTS v_activity_message;
Drop view if EXISTS v_player_activity_message;

ALTER TABLE "activity_message_i18n" ALTER COLUMN "activity_description" TYPE text COLLATE "default";

ALTER TABLE activity_rule DROP COLUMN IF EXISTS is_designated_rank;

CREATE OR REPLACE VIEW "v_activity_message" AS
  SELECT a.id,
    b.name,
    a.activity_state,
    a.start_time,
    a.end_time,
    a.activity_classify_key,
    c.activity_name,
    c.activity_version,
    a.is_display,
    c.activity_cover,
    ( SELECT count(1) AS count
      FROM activity_player_apply d
      WHERE ((d.activity_message_id = a.id) AND ((d.check_state)::text = '1'::text))) AS acount,
    b.code,
    c.activity_description,
    e.is_audit,
    b.logo,
    b.introduce,
    CASE
    WHEN (((a.start_time < now()) AND (a.end_time > now())) AND ((a.activity_state)::text <> 'draft'::text)) THEN 'processing'::text
    WHEN ((a.start_time > now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 'notStarted'::text
    WHEN ((a.end_time < now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 'finished'::text
    WHEN ((a.activity_state)::text = 'draft'::text) THEN 'notStarted'::text
    ELSE NULL::text
    END AS states,
    a.is_deleted,
    a.check_status,
    ((e.rank)::text || ','::text) AS rankid,
    a.create_time
  FROM activity_message a
  LEFT JOIN activity_type b ON a.activity_type_code::text = b.code::text
          LEFT JOIN activity_message_i18n c ON c.activity_message_id = a.id
         LEFT JOIN activity_rule e ON e.activity_message_id = a.id;


CREATE OR REPLACE VIEW "v_player_activity_message" AS
  SELECT a.id,
    a.activity_state,
    a.start_time,
    a.end_time,
    a.activity_classify_key,
    a.is_deleted,
    a.is_display,
    b.code,
    c.activity_name,
    c.activity_version,
    c.activity_cover,
    c.activity_description,
    c.activity_overview,
    CASE
    WHEN (((a.start_time < now()) AND (a.end_time > now())) AND ((a.activity_state)::text <> 'draft'::text)) THEN 'processing'::text
    WHEN ((a.start_time > now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 'notStarted'::text
    WHEN ((a.end_time < now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 'finished'::text
    WHEN ((a.activity_state)::text = 'draft'::text) THEN 'draft'::text
    ELSE NULL::text
    END AS states,
    e.effective_time,
    ((e.rank)::text || ','::text) AS rankid,
    e.places_number,
    e.claim_period,
    a.check_status
  FROM activity_message a
  LEFT JOIN activity_type b ON a.activity_type_code::text = b.code::text
          LEFT JOIN activity_message_i18n c ON c.activity_message_id = a.id
         LEFT JOIN activity_rule e ON e.activity_message_id = a.id;

UPDATE notice_tmpl set title='${year}年${month}月${period}期返佣结算' where event_type= 'RETURN_COMMISSION_SUCCESS';


INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'BIND_EMAIL_VERIFICATION_CODE', 'email', 'c626c4ede06b4b01a2b6f923e5616bad', 't', 'zh_CN', '邮箱绑定', '${verificationCode}我实在不知道要写什么！', 't', '邮箱绑定', '${verificationCode}我实在不知道要写什么！', '2015-09-18 14:39:23.462204', '1', NULL, NULL, 't'
WHERE 'BIND_EMAIL_VERIFICATION_CODE' NOT in (SELECT event_type FROM notice_tmpl WHERE publish_method='email' AND locale='zh_CN');

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'BIND_EMAIL_VERIFICATION_CODE', 'email', 'c626c4ede06b4b01a2b6f923e5616bad', 't', 'zh_TW', '邮箱绑定', '${verificationCode}我实在不知道要写什么！', 't', '邮箱绑定', '${verificationCode}我实在不知道要写什么！', '2015-09-18 14:39:23.462204', '1', NULL, NULL, 't'
WHERE 'BIND_EMAIL_VERIFICATION_CODE' NOT in (SELECT event_type FROM notice_tmpl WHERE publish_method='email' AND locale='zh_TW');

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'BIND_EMAIL_VERIFICATION_CODE', 'email', 'c626c4ede06b4b01a2b6f923e5616bad', 't', 'en_US', '邮箱绑定', '${verificationCode}我实在不知道要写什么！', 't', '邮箱绑定', '${verificationCode}我实在不知道要写什么！', '2015-09-18 14:39:23.462204', '1', NULL, NULL, 't'
WHERE 'BIND_EMAIL_VERIFICATION_CODE' NOT in (SELECT event_type FROM notice_tmpl WHERE publish_method='email' AND locale='en_US');


