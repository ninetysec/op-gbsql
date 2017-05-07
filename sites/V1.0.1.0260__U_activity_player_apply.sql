-- auto gen by bruce 2016-09-15 10:23:03
select redo_sqls($$
	ALTER TABLE activity_player_apply ADD COLUMN ip_apply int8;
	ALTER TABLE activity_player_apply ADD COLUMN ip_dict_code varchar(100);
	ALTER TABLE activity_player_apply ADD COLUMN remark varchar(300);
$$);

COMMENT ON COLUMN activity_player_apply.ip_apply  IS '玩家申请优惠时ip';
COMMENT ON COLUMN activity_player_apply.ip_dict_code  IS 'ip所在地区';
COMMENT ON COLUMN activity_player_apply.remark  IS '备注';

DROP VIEW IF EXISTS v_activity_player_apply;
CREATE OR REPLACE VIEW "v_activity_player_apply" AS
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
    p.remark
  FROM activity_player_apply p
    LEFT JOIN activity_message m ON p.activity_message_id = m.id;

COMMENT ON VIEW "v_activity_player_apply" IS '活动申请玩家视图 -- orange';