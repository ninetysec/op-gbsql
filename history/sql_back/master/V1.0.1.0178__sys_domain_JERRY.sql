-- auto gen by jerry 2015-11-09 15:02:26

drop view IF EXISTS v_activity_message;
drop view IF EXISTS v_player_activity_message;

alter table "activity_message" alter  COLUMN  activity_classify_key  type varchar(64);


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
    WHERE (d.activity_message_id = a.id)) AS acount,
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
  a.is_deleted
FROM activity_message a
LEFT JOIN activity_type b ON a.activity_type_code = b.code
        LEFT JOIN activity_message_i18n c ON c.activity_message_id = a.id
       LEFT JOIN activity_rule e ON e.activity_message_id = a.id;


CREATE OR REPLACE VIEW v_player_activity_message AS SELECT a.id,
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
                                                            e.places_number
                                                           FROM activity_message a
                                                           LEFT JOIN activity_type b ON a.activity_type_code = b.code
                                                                   LEFT JOIN activity_message_i18n c ON c.activity_message_id = a.id
                                                                  LEFT JOIN activity_rule e ON e.activity_message_id = a.id;


INSERT INTO "activity_type" ("code", "name", "introduce", "logo") VALUES ('content', '活动内容', '只发送优惠活动内容，不进行规则定制', 'static/mcenter/images/content-events.jpg');


