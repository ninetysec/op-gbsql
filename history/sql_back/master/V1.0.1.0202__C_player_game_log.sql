-- auto gen by cheery 2015-11-17 11:01:04
--添加player_game_log表
CREATE TABLE IF NOT EXISTS "player_game_log" (
  "id" SERIAL4,
  "api_id" int4,
  "game_id" int4,
  "user_id" int4,
  "login_time" timestamp(6),
  CONSTRAINT "player_game_log_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "player_game_log" OWNER TO "postgres";

COMMENT ON TABLE "player_game_log" IS 'player_game_log表-- susu';

COMMENT ON COLUMN "player_game_log"."id" IS '主键';

COMMENT ON COLUMN "player_game_log"."api_id" IS 'api主键';

COMMENT ON COLUMN "player_game_log"."game_id" IS '游戏ID';

COMMENT ON COLUMN "player_game_log"."user_id" IS '玩家ID';

COMMENT ON COLUMN "player_game_log"."login_time" IS '登录时间';

--修改活动信息表
ALTER TABLE activity_message DROP COLUMN IF EXISTS activity_audit_state;
select redo_sqls($$
    ALTER TABLE activity_message ADD COLUMN update_user_id int4;
    ALTER TABLE activity_message ADD COLUMN update_time timestamp(6);
    ALTER TABLE activity_message ADD COLUMN check_user_id int4;
    ALTER TABLE activity_message ADD COLUMN check_status varchar(32);
    ALTER TABLE activity_message ADD COLUMN check_time timestamp(6);
    ALTER TABLE activity_message ADD COLUMN reason_title varchar(128);
    ALTER TABLE activity_message ADD COLUMN reason_content varchar(1000);
$$);

COMMENT ON COLUMN activity_message.update_user_id IS '更新人id';
COMMENT ON COLUMN activity_message.update_time IS '更新时间';
COMMENT ON COLUMN activity_message.check_user_id IS '审核人id';
COMMENT ON COLUMN activity_message.check_status IS '审核状态common.check_status(通过,失败,待审核)';
COMMENT ON COLUMN activity_message.check_time IS '审核时间';
COMMENT ON COLUMN activity_message.reason_title IS '失败原因标题';
COMMENT ON COLUMN activity_message.reason_content IS '失败原因内容';

--修改优惠活动视图
DROP VIEW IF EXISTS v_activity_message;
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
    WHEN (((a.start_time < now()) AND (a.end_time > now())) AND ((a.activity_state)::text <> 'draft'::text)) THEN 'processing'::text
    WHEN ((a.start_time > now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 'notStarted'::text
    WHEN ((a.end_time < now()) AND ((a.activity_state)::text <> 'draft'::text)) THEN 'finished'::text
    WHEN ((a.activity_state)::text = 'draft'::text) THEN 'notStarted'::text
    ELSE NULL::text
    END AS states,
    a.is_deleted,
    a.check_status
  FROM activity_message a
    LEFT JOIN activity_type b ON a.activity_type_code = b.code
    LEFT JOIN activity_message_i18n c ON c.activity_message_id = a.id
    LEFT JOIN activity_rule e ON e.activity_message_id = a.id;

--更新菜单地址
UPDATE "sys_resource" SET "url"='vPlayerGameOrder/list.html'  WHERE ("id"='4301');
UPDATE "sys_resource" SET "url"='vPlayerGameOrder/list.html?search.orderState=pending_settle' WHERE ("id"='4302');
update sys_resource set url = '/setting/vsubAccount/list.html' WHERE "name" = '系统账号'  AND subsys_code = 'mcenter';
--修改站长中心资金记录地址
update sys_resource SET url = '/vPlayerTransaction/list.html' WHERE "name" = '资金记录' AND "subsys_code" = 'mcenter';

----------站长中心添加默认角色 和角色默认菜单
DELETE from sys_role where subsys_code = 'mcenter' AND name in ('default_role_redact','default_role_recharge','default_role_service');
WITH rows AS (
  INSERT INTO "sys_role" ( "name", "status", "subsys_code",  "built_in")
    SELECT 'default_role_service', '1','mcenter','t'   where 'default_role_service' not in (SELECT name from sys_role where subsys_code = 'mcenter')
  RETURNING id
),role_row as(
  INSERT INTO sys_role_default_resource (role_id,resource_id)
    SELECT r.id,sr.id FROM rows r FULL JOIN (SELECT id from sys_resource  where subsys_code = 'mcenter')sr on TRUE where r.id NOTNULL
  RETURNING  role_id,resource_id
)
INSERT INTO sys_role_resource (role_id,resource_id)
  SELECT role_id,resource_id FROM role_row WHERE role_id NOTNULL;


WITH rows AS (
  INSERT INTO "sys_role" ( "name", "status", "subsys_code",  "built_in")
    SELECT 'default_role_redact', '1','mcenter','t' where 'default_role_redact' not in (SELECT name from sys_role where subsys_code = 'mcenter')
  RETURNING id
),role_row as(
  INSERT INTO sys_role_default_resource (role_id,resource_id)
    SELECT r.id,sr.id FROM rows r FULL JOIN (SELECT id from sys_resource  where subsys_code = 'mcenter')sr on TRUE where r.id NOTNULL
  RETURNING  role_id,resource_id
)
INSERT INTO sys_role_resource (role_id,resource_id)
  SELECT role_id,resource_id FROM role_row WHERE role_id NOTNULL;

WITH rows AS (
  INSERT INTO "sys_role" ( "name", "status", "subsys_code",  "built_in")
    SELECT  'default_role_recharge', '1','mcenter','t'  where 'default_role_recharge' not in (SELECT name from sys_role where subsys_code = 'mcenter')
  RETURNING id
),role_row as(
  INSERT INTO sys_role_default_resource (role_id,resource_id)
    SELECT r.id,sr.id FROM rows r FULL JOIN (SELECT id from sys_resource  where subsys_code = 'mcenter')sr on TRUE where r.id NOTNULL
  RETURNING  role_id,resource_id
)
INSERT INTO sys_role_resource (role_id,resource_id)
  SELECT role_id,resource_id FROM role_row WHERE role_id NOTNULL;

-----玩家交易视图
drop VIEW if exists v_player_transaction ;
CREATE or REPLACE VIEW v_player_transaction AS
  SELECT
    pt.id,
    pt.transaction_no,
    pt.create_time,
    pt.transaction_type,
    pt.remark,
    pt.transaction_money,
    pt.balance,
    pt.status,
    pt.player_id,
    pt.failure_reason,
    pt.source_id,
    pt.effective_transaction,
    pt.recharge_audit_points,
    pt.relaxing_quota,
    pt.administrative_fee,
    pt.favorable_total_amount,
    pt.favorable_audit_points,
    pt.deduct_favorable,
    pt.is_satisfy_audit,
    pt.is_clear_audit,
    pt.api_money,
    pt.completion_time,
    pt.fund_type,
    pt.transaction_way,
    pt.transaction_data,
    su.username
  from player_transaction pt LEFT JOIN sys_user su on pt.player_id = su.id;
COMMENT ON VIEW "v_player_transaction" IS '玩家交易视图-jeff';

--参数表 新增 收款账号-隐藏设置 处理客服
INSERT INTO "sys_param" (
  "module",
  "param_type",
  "param_code",
  "param_value",
  "default_value",
  "order_num",
  "remark",
  "parent_code",
  "active",
  "site_id"
)
  SELECT
    'content',
    'pay_account',
    'handle_customer_service',
    '',
    '',
    '1',
    '收款账号-隐藏设置 处理客服',
    NULL,
    't',
    NULL
  where 'handle_customer_service' not in (SELECT param_code FROM sys_param where module = 'content' AND param_type = 'pay_account');


----玩家视图修改
DROP VIEW IF EXISTS v_user_player;
CREATE OR REPLACE VIEW v_user_player AS
  SELECT a.id,
    a.rank_id,
    b.nickname,
    b.sex,
    b.constellation,
    b.birthday,
    b.country,
    b.region,
    b.city,
    b.nation,
    a.total_assets,
    a.phone_code,
    a.wallet_balance,
    a.synchronization_time,
    a.special_focus,
    b.create_user,
    b.create_time,
    a.balance_type,
    a.balance_freeze_start_time,
    a.balance_freeze_end_time,
    a.freeze_code,
    a.balance_freeze_remark,
    a.account_freeze_remark,
    b.owner_id AS user_agent_id,
    a.rakeback_id,
    a.level,
    b.default_currency,
    a.ohter_contact_information,
    b.username,
    b.password,
    b.dept_id,
    b.status,
    b.freeze_type,
    b.freeze_start_time,
    b.freeze_end_time,
    b.freeze_code AS user_freeze_code,
    b.register_ip,
    b.owner_id AS agent_id,
    d.username AS agent_name,
    f.username AS general_agent_name,
    f.id AS general_agent_id,
    g.id AS on_line_id,
    b.real_name,
    b.default_locale,
    a.rakeback,
    a.backwash_total_amount,
    a.backwash_balance_amount,
    a.backwash_recharge_warn,
    a.transaction_syn_time,
    ( SELECT count(1) AS remarkcount
      FROM remark player_remark
      WHERE (player_remark.player_id = a.id)) AS remarkcount,
    ( SELECT count(1) AS tagcount
      FROM player_tag
      WHERE (player_tag.player_id = a.id)) AS tagcount,
    b.default_timezone,
    r.rank_name,
    a.recharge_count,
    a.recharge_total,
    a.recharge_max_amount,
    a.withdraw_count AS tx_count,
    a.withdraw_total AS tx_total,
    a.level_lock,
    r.risk_marker,
    ( SELECT way.contact_value
      FROM notice_contact_way way
      WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '110'::text))
      LIMIT 1) AS mobile_phone,
    ( SELECT way.contact_value
      FROM notice_contact_way way
      WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '201'::text))
      LIMIT 1) AS mail,
    ( SELECT way.contact_value
      FROM notice_contact_way way
      WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '301'::text))
      LIMIT 1) AS qq,
    ( SELECT way.contact_value
      FROM notice_contact_way way
      WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '302'::text))
      LIMIT 1) AS msn,
    ( SELECT way.contact_value
      FROM notice_contact_way way
      WHERE ((way.user_id = a.id) AND ((way.contact_type)::text = '303'::text))
      LIMIT 1) AS skype,
    rs.name AS rakeback_name,
    a.total_profit_loss,
    a.total_trade_volume,
    a.total_effective_volume,
    a.create_channel
  FROM ((((((user_player a
  JOIN sys_user b ON ((a.id = b.id)))
             LEFT JOIN sys_user d ON ((b.owner_id = d.id)))
            LEFT JOIN sys_user f ON ((d.owner_id = f.id)))
           LEFT JOIN player_rank r ON ((a.rank_id = r.id)))
          LEFT JOIN sys_on_line_session g ON ((a.id = g.sys_user_id)))
         LEFT JOIN rakeback_set rs ON ((a.rakeback_id = rs.id)));

COMMENT ON VIEW v_user_agent_manage IS '玩家视图 -- Jeff';