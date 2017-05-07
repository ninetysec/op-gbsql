-- auto gen by admin 2016-04-19 21:02:37
 select redo_sqls($$
ALTER TABLE activity_message_i18n ADD COLUMN activity_affiliated character varying(255);
$$);

COMMENT ON COLUMN activity_message_i18n.activity_affiliated IS '活动附图';

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
    c.activity_affiliated
   FROM (((activity_message a
     LEFT JOIN activity_type b ON (((a.activity_type_code)::text = (b.code)::text)))
     LEFT JOIN activity_message_i18n c ON ((c.activity_message_id = a.id)))
     LEFT JOIN activity_rule e ON ((e.activity_message_id = a.id)));

select redo_sqls($$
ALTER TABLE sys_user ADD COLUMN secpwd_freeze_start_time timestamp(6);
ALTER TABLE sys_user ADD COLUMN secpwd_freeze_end_time timestamp(6);
ALTER TABLE sys_user ADD COLUMN secpwd_error_times integer;
$$);

COMMENT ON COLUMN sys_user.secpwd_freeze_start_time IS '安全密码冻结开始时间';
COMMENT ON COLUMN sys_user.secpwd_freeze_end_time IS '安全密码冻结结束时间';
COMMENT ON COLUMN sys_user.secpwd_error_times IS '安全密码输错次数';