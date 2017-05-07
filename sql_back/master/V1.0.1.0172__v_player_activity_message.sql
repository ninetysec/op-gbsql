-- auto gen by cheery 2015-11-05 07:52:41
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
    e.places_number
  FROM activity_message a
    LEFT JOIN activity_type b ON a.activity_type_code = b.code
    LEFT JOIN activity_message_i18n c ON c.activity_message_id = a.id
    LEFT JOIN activity_rule e ON e.activity_message_id = a.id;


DROP VIEW IF EXISTS v_user_agent ;
CREATE OR REPLACE VIEW  v_user_agent AS
  SELECT a.id,
    u.real_name,
    u.username,
    u.nickname,
    a.sites_id,
    u.owner_id AS parent_id,
    a.regist_code,
    a.built_in,
    a.player_rank_id,
    a.promotion_resources,
    a.create_channel,
    a.account_balance,
    a.total_rebate,
    a.check_time,
    a.check_user_id,
    a.rebate_count,
    a.withdraw_count,
    a.freezing_funds_balance,
    ( SELECT w.contact_value
      FROM notice_contact_way w
      WHERE ((a.id = w.user_id) AND ((w.contact_type)::text = '110'::text))
      LIMIT 1) AS mobil_phone,
    ( SELECT w.contact_value
      FROM notice_contact_way w
      WHERE ((a.id = w.user_id) AND ((w.contact_type)::text = '201'::text))
      LIMIT 1) AS mail,
    u.status,
    u.user_type
  FROM user_agent a,
    sys_user u
  WHERE (a.id = u.id);
