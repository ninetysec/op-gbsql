-- auto gen by cheery 2015-10-14 14:45:05
drop view IF EXISTS v_activity_message;
DROP VIEW IF EXISTS v_activity_player_apply;

ALTER TABLE activity_message_i18n DROP COLUMN IF EXISTS activity_classify_id;
ALTER TABLE activity_message DROP COLUMN IF EXISTS activity_cover;
ALTER TABLE activity_message DROP COLUMN IF EXISTS activity_form_id;
ALTER TABLE activity_message DROP COLUMN IF EXISTS is_show;

select redo_sqls($$
  ALTER TABLE activity_message_i18n ADD COLUMN activity_cover varchar(255);

  ALTER TABLE activity_message ADD COLUMN activity_audit_state varchar(32);
  ALTER TABLE activity_message ADD COLUMN create_time timestamp(6);
  ALTER TABLE activity_message ADD COLUMN user_id int4;
  ALTER TABLE activity_message ADD COLUMN user_name varchar(32);
  ALTER TABLE activity_message ADD COLUMN activity_classify_key varchar(32);
  ALTER TABLE activity_message ADD COLUMN activity_type_code varchar(32);
  ALTER TABLE activity_message ADD COLUMN is_display bool;
$$);

COMMENT ON COLUMN activity_message_i18n.activity_cover IS '活动封面';

COMMENT ON COLUMN activity_message_i18n.activity_version IS '活动版本site_language';

COMMENT ON COLUMN activity_message.activity_audit_state IS '活动审核状态operation.activity_audit_state(待审核,部分审核,已审核)';

COMMENT ON COLUMN activity_message.create_time IS '活动创建时间';

COMMENT ON COLUMN activity_message.user_id IS '创建人id';

COMMENT ON COLUMN activity_message.user_name IS '创建人';

COMMENT ON COLUMN activity_message.activity_classify_key IS '活动分类site_i18n.operate.operate_activity_classify';

COMMENT ON COLUMN activity_message.activity_type_code IS '活动类型代码';

COMMENT ON COLUMN activity_message.is_display IS '是否展示';


--------------视图创建--v_activity_message----活动消息主从表，活动形式表 做个视图----------------
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
    c.activity_description
  FROM activity_message a
    LEFT JOIN activity_type b ON  a.activity_type_code = b.code
    LEFT JOIN activity_message_i18n c ON c.activity_message_id = a.id;

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
    m.is_display
  FROM (activity_player_apply p
    LEFT JOIN activity_message m ON ((p.activity_message_id = m.id)));

ALTER TABLE "v_activity_player_apply" OWNER TO "postgres";
COMMENT ON VIEW "v_activity_player_apply" IS '活动申请玩家视图 -- orange';