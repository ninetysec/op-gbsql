-- auto gen by linsen 2018-04-16 15:39:38
-- 玩家活动信息 by kobe
DROP VIEW IF EXISTS v_player_activity_message;
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
            WHEN ((a.start_time <= now()) AND (a.end_time >= now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 'processing'::text
            WHEN ((a.start_time > now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 'notStarted'::text
            WHEN ((a.end_time < now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 'finished'::text
            WHEN ((a.activity_state)::text = 'draft'::text) THEN 'draft'::text
            ELSE NULL::text
        END AS states,
    e.effective_time,
    ((e.rank)::text || ','::text) AS rankid,
    e.places_number,
    e.claim_period,
    a.check_status,
    e.is_all_rank,
    c.activity_affiliated,
    a.classify_order_num,
    a.float_pic_show_in_pc,
    a.float_pic_show_in_mobile,
    c.activity_terminal_type
   FROM (((activity_message a
     LEFT JOIN activity_type b ON (((a.activity_type_code)::text = (b.code)::text)))
     LEFT JOIN activity_message_i18n c ON ((c.activity_message_id = a.id)))
     LEFT JOIN activity_rule e ON ((e.activity_message_id = a.id)));

COMMENT ON VIEW "v_player_activity_message" IS '玩家活动信息 create by kobe';
