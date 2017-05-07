-- auto gen by cheery 2015-10-23 16:33:17

drop view v_activity_message;

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
    WHEN ((a.activity_state)::text = 'draft'::text) THEN 'draft'::text
    ELSE NULL::text
    END AS states
  FROM activity_message a
    LEFT JOIN activity_type b ON a.activity_type_code = b.code
    LEFT JOIN activity_message_i18n c ON c.activity_message_id = a.id
    LEFT JOIN activity_rule e ON e.activity_message_id = a.id;
