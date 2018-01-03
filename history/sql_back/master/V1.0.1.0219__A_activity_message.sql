-- auto gen by cheery 2015-11-24 01:28:43
COMMENT ON COLUMN "activity_message"."check_status" IS '审核状态content.check_status(通过,失败,待审核)';

SELECT redo_sqls($$
    ALTER TABLE agent_rebate_order ADD COLUMN settlement_rebate_id int4;
  $$);

COMMENT ON COLUMN agent_rebate_order.settlement_rebate_id IS 'settlement_rebate主键';

CREATE OR REPLACE VIEW "v_player_activity_message" AS
  SELECT
    a.id,
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
    WHEN (((a.start_time < now()) AND (a.end_time > now())) AND ((a.activity_state) :: TEXT <> 'draft' :: TEXT))
      THEN 'processing' :: TEXT
    WHEN ((a.start_time > now()) AND ((a.activity_state) :: TEXT <> 'draft' :: TEXT))
      THEN 'notStarted' :: TEXT
    WHEN ((a.end_time < now()) AND ((a.activity_state) :: TEXT <> 'draft' :: TEXT))
      THEN 'finished' :: TEXT
    WHEN ((a.activity_state) :: TEXT = 'draft' :: TEXT)
      THEN 'draft' :: TEXT
    ELSE NULL :: TEXT
    END                               AS states,
    e.effective_time,
    ((e.rank) :: TEXT || ',' :: TEXT) AS rankid,
    e.places_number,
    e.claim_period,
    e.is_designated_rank,
    a.check_status
  FROM activity_message a
    LEFT JOIN activity_type b ON a.activity_type_code = b.code
    LEFT JOIN activity_message_i18n c ON c.activity_message_id = a.id
    LEFT JOIN activity_rule e ON e.activity_message_id = a.id;

SELECT redo_sqls($$
    ALTER TABLE "activity_player_apply"
    ADD COLUMN "start_time" timestamp,
    ADD COLUMN "end_time" timestamp;
  $$);

COMMENT ON COLUMN "activity_player_apply"."start_time" IS '活动结算起始时间';

COMMENT ON COLUMN "activity_player_apply"."end_time" IS '活动结算起始时间';