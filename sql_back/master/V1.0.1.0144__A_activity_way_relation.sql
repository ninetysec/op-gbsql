-- auto gen by cheery 2015-10-25 17:02:30
select redo_sqls($$
    ALTER TABLE "activity_way_relation" ADD COLUMN "activity_rule_id" int4;
$$);

COMMENT ON COLUMN "activity_way_relation"."activity_rule_id" IS '活动规则关联id';

CREATE OR REPLACE VIEW v_activity_message AS
  SELECT
    A . ID,
    b. NAME,
    A .activity_state,
    A .start_time,
    A .end_time,
    A .activity_classify_key,
    C .activity_name,
    C .activity_version,
    A .is_display,
    C .activity_cover,
    (
      SELECT
    COUNT (1) AS COUNT
      FROM
        activity_player_apply d
      WHERE
        (d.activity_message_id = A . ID)
    ) AS acount,
    b.code,
    C .activity_description,
    e.is_audit,
    b.logo,
    b.introduce,
    CASE
    WHEN (
      (
        (A .start_time < now())
        AND (A .end_time > now())
      )
      AND (
        (A .activity_state) :: TEXT <> 'draft' :: TEXT
      )
    ) THEN
      'processing' :: TEXT
    WHEN (
      (A .start_time > now())
      AND (
        (A .activity_state) :: TEXT <> 'draft' :: TEXT
      )
    ) THEN
      'notStarted' :: TEXT
    WHEN (
      (A .end_time < now())
      AND (
        (A .activity_state) :: TEXT <> 'draft' :: TEXT
      )
    ) THEN
      'finished' :: TEXT
    WHEN (
      (A .activity_state) :: TEXT = 'draft' :: TEXT
    ) THEN
      'draft' :: TEXT
    ELSE
      NULL :: TEXT
    END AS states,
    A .is_deleted
  FROM
    activity_message A
  LEFT JOIN activity_type b ON A .activity_type_code = b.code
  LEFT JOIN activity_message_i18n C ON C .activity_message_id = A . ID
  LEFT JOIN activity_rule e ON e.activity_message_id = A . ID;
