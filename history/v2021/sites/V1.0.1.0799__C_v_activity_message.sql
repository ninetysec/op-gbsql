-- auto gen by linsen 2018-05-07 09:04:31
--更改activity_rule存款方式的字段长度 by steffan

drop view if exists v_activity_message;
drop view if exists v_activity_message_hall;

select redo_sqls($$
 alter table activity_rule alter COLUMN deposit_way type varchar(512) ;
$$);

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
            WHEN ((a.is_remove IS NOT NULL) AND (a.is_remove = true)) THEN 'remove'::text
            WHEN ((a.start_time <= now()) AND (a.end_time >= now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 'processing'::text
            WHEN ((a.start_time > now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 'notStarted'::text
            WHEN ((a.end_time < now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 'finished'::text
            WHEN ((a.activity_state)::text = 'draft'::text) THEN 'notStarted'::text
            ELSE NULL::text
        END AS states,
    a.is_deleted,
    a.check_status,
    ((e.rank)::text || ','::text) AS rankid,
    a.create_time,
    e.preferential_amount_limit,
    e.is_all_rank,
    c.activity_affiliated,
    a.order_num,
    e.deposit_way,
    a.is_read,
    a.is_remove,
    a.classify_order_num,
    a.float_pic_show_in_pc,
    a.float_pic_show_in_mobile,
        CASE
            WHEN ((a.is_remove IS NOT NULL) AND (a.is_remove = true)) THEN 4
            WHEN ((a.start_time <= now()) AND (a.end_time >= now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 1
            WHEN ((a.start_time > now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 2
            WHEN ((a.end_time < now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 3
            WHEN ((a.activity_state)::text = 'draft'::text) THEN 2
            ELSE NULL::integer
        END AS list_order_num,
    c.activity_terminal_type,
    e.claim_period,
    e.effective_time,
    e.places_number
   FROM (((activity_message a
     LEFT JOIN activity_type b ON (((a.activity_type_code)::text = (b.code)::text)))
     LEFT JOIN activity_message_i18n c ON ((c.activity_message_id = a.id)))
     LEFT JOIN activity_rule e ON ((e.activity_message_id = a.id)));


COMMENT ON VIEW "v_activity_message" IS '优惠活动视图 modify by steffan';

CREATE OR REPLACE VIEW "v_activity_message_hall" AS
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
            WHEN ((a.is_remove IS NOT NULL) AND (a.is_remove = true)) THEN 'remove'::text
            WHEN ((a.start_time <= now()) AND (a.end_time >= now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 'processing'::text
            WHEN ((a.start_time > now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 'notStarted'::text
            WHEN ((a.end_time < now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 'finished'::text
            WHEN ((a.activity_state)::text = 'draft'::text) THEN 'notStarted'::text
            ELSE NULL::text
        END AS states,
    a.is_deleted,
    a.check_status,
    ((e.rank)::text || ','::text) AS rankid,
    a.create_time,
    e.preferential_amount_limit,
    e.is_all_rank,
    c.activity_affiliated,
    a.order_num,
    e.deposit_way,
    a.is_read,
    a.is_remove,
    c.activity_terminal_type,
    e.effective_time,
        CASE
            WHEN ((a.is_remove IS NOT NULL) AND (a.is_remove = true)) THEN 4
            WHEN ((a.start_time <= now()) AND (a.end_time >= now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 1
            WHEN ((a.start_time > now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 2
            WHEN ((a.end_time < now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 3
            WHEN ((a.activity_state)::text = 'draft'::text) THEN 2
            ELSE NULL::integer
        END AS list_order_num
   FROM (((activity_message a
     LEFT JOIN activity_type b ON (((a.activity_type_code)::text = (b.code)::text)))
     LEFT JOIN activity_message_i18n c ON ((c.activity_message_id = a.id)))
     LEFT JOIN activity_rule e ON ((e.activity_message_id = a.id)));
COMMENT ON VIEW "v_activity_message_hall" IS '活动大厅视图 create by steffan';