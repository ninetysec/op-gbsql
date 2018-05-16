-- auto gen by linsen 2018-04-10 11:08:37

-- 修改活动玩家申请表  modify by steffan
SELECT redo_sqls($$
	alter table activity_player_apply add column "transaction_no" varchar(32);
	alter table activity_player_apply add column "activity_terminal_type" varchar(8) ;
$$);

COMMENT ON COLUMN  "activity_player_apply"."transaction_no" IS '交易号';
COMMENT ON COLUMN  "activity_player_apply"."activity_terminal_type" IS '活动终端类型';


--  活动效果监控视图　add by steffan

DROP VIEW IF EXISTS v_activity_monitor;
CREATE OR REPLACE VIEW "v_activity_monitor" AS
 SELECT p.id,
    p.activity_message_id,
    p.user_id AS player_id,
    p.user_name AS player_name,
    p.register_time,
    p.rank_id,
    p.rank_name,
    p.risk_marker,
    p.apply_time,
    p.check_user_id,
    p.check_time,
    p.check_state,
    p.reason_title,
    p.reason_content,
    m.activity_type_code,
    m.start_time,
    m.end_time,
    m.create_time,
    m.user_id AS message_create_person_id,
    m.user_name AS message_create_person_name,
    m.is_display,
    p.player_recharge_id,
    p.ip_apply,
    p.ip_dict_code,
    p.remark,
    c.activity_name,
    c.activity_version,
    pp.preferential_audit,
    pp.preferential_value,
    m.activity_classify_key,
    b.code,
    su.username,
    null script_check,
        CASE
            WHEN ((p.check_state)::text = '0'::text) THEN '1'::character varying
            WHEN ((p.check_state)::text = '1'::text) THEN '0'::character varying
            ELSE p.check_state
        END AS order_num
   FROM (activity_player_apply p
     LEFT JOIN activity_message m ON p.activity_message_id = m.id
     LEFT JOIN activity_player_preferential pp on pp.activity_player_apply_id = p.id
     LEFT JOIN activity_message_i18n c ON c.activity_message_id = m.id
LEFT JOIN activity_type b ON (((m.activity_type_code)::text = (b.code)::text))
 LEFT JOIN sys_user su on p.check_user_id = su.id);

COMMENT ON VIEW "v_activity_monitor" IS '活动效果监控视图 -- create by steffan';



-- 活动大厅视图  add by steffan

DROP VIEW IF EXISTS v_activity_message_hall;
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
