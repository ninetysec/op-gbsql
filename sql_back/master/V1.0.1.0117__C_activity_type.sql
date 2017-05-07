-- auto gen by cheery 2015-10-14 13:42:11
drop view IF EXISTS v_activity_preferential;
drop view IF EXISTS v_activity_language_count;
drop view IF EXISTS v_activity_message_list;
drop table IF EXISTS activity_player_message;
drop table IF EXISTS activity_form;
drop table IF EXISTS activity_preferential_way;

--活动类型表activity_type
CREATE TABLE IF NOT EXISTS "activity_type" (
  "id" SERIAL4 NOT NULL,
  "code" varchar(32),
  "name" varchar(100),
  "introduce" varchar(1000),
  "logo" varchar(100),
  CONSTRAINT "activity_type_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "activity_type" IS '活动类型表--eagle';
COMMENT ON COLUMN "activity_type"."id" IS '主键';
COMMENT ON COLUMN "activity_type"."code" IS '活动类型代码';
COMMENT ON COLUMN "activity_type"."name" IS '活动类型名称';
COMMENT ON COLUMN "activity_type"."introduce" IS '活动类型介绍';
COMMENT ON COLUMN "activity_type"."logo" IS '活动类型logo';

------插入内置数据-------
INSERT INTO activity_type (code,name,introduce,logo)
  SELECT 'first_deposit','首存送','首次存款达到 一定金额可获得的优惠','static/mcenter/images/first-events.jpg'
  WHERE 'first_deposit' not in (SELECT code from activity_type);

INSERT INTO activity_type (code,name,introduce,logo)
  SELECT 'regist_send','注册送','玩家成功注册后可获得的奖励','static/mcenter/images/register-events.jpg'
  WHERE 'regist_send' not in (SELECT code from activity_type);

INSERT INTO activity_type (code,name,introduce,logo)
  SELECT 'deposit','存就送','除首存外，玩家每次存款可以获得的优惠','static/mcenter/images/events.jpg'
  WHERE 'deposit' not in (SELECT code from activity_type);

INSERT INTO activity_type (code,name,introduce,logo)
  SELECT 'relief_fund','救济金','针对玩家总资产过低时发起的优惠活动','static/mcenter/images/relief-events.jpg'
  WHERE 'relief_fund' not in (SELECT code from activity_type);

INSERT INTO activity_type (code,name,introduce,logo)
  SELECT 'back_water','返水优惠','玩家在游戏里下单时可获得的返水优惠','static/mcenter/images/return-events.jpg'
  WHERE 'back_water' not in (SELECT code from activity_type);

INSERT INTO activity_type (code,name,introduce,logo)
  SELECT 'profit_loss','盈亏返利','盈亏返利说明','static/mcenter/images/events.jpg'
  WHERE 'profit_loss' not in (SELECT code from activity_type);

--活动申请玩家表activity_player_apply
CREATE TABLE IF NOT EXISTS "activity_player_apply" (
  "id" SERIAL4 NOT NULL,
  "activity_message_id" int4,
  "user_id" int4,
  "user_name" varchar(32) COLLATE "default",
  "register_time" timestamp(6),
  "rank_id" int4,
  "rank_name" varchar(50) COLLATE "default",
  "risk_marker" bool,
  "apply_time" timestamp(6),
  "check_user_id" int4,
  "check_time" timestamp(6),
  "check_state" varchar(32) COLLATE "default",
  "reason_title" varchar(128) COLLATE "default",
  "reason_content" varchar(1000) COLLATE "default",
  CONSTRAINT "activity_player_apply_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "activity_player_apply" OWNER TO "postgres";

COMMENT ON TABLE "activity_player_apply" IS '活动申请玩家表--eagle';

COMMENT ON COLUMN "activity_player_apply"."id" IS '主键';

COMMENT ON COLUMN "activity_player_apply"."activity_message_id" IS '活动信息id';

COMMENT ON COLUMN "activity_player_apply"."user_id" IS '玩家账号ID';

COMMENT ON COLUMN "activity_player_apply"."user_name" IS '玩家账号';

COMMENT ON COLUMN "activity_player_apply"."register_time" IS '注册时间';

COMMENT ON COLUMN "activity_player_apply"."rank_id" IS '层级ID';

COMMENT ON COLUMN "activity_player_apply"."rank_name" IS '层级名称';

COMMENT ON COLUMN "activity_player_apply"."risk_marker" IS '层级危险标示';

COMMENT ON COLUMN "activity_player_apply"."apply_time" IS '申请时间';

COMMENT ON COLUMN "activity_player_apply"."check_user_id" IS '审核人id';

COMMENT ON COLUMN "activity_player_apply"."check_time" IS '审核时间';

COMMENT ON COLUMN "activity_player_apply"."check_state" IS '审核状态operation.check_state(审核通过,审核失败)';

COMMENT ON COLUMN "activity_player_apply"."reason_title" IS '失败原因标题';

COMMENT ON COLUMN "activity_player_apply"."reason_content" IS '失败原因内容';

---玩家优惠信息表activity_player_preferential
CREATE TABLE IF NOT EXISTS "activity_player_preferential" (
  "id" SERIAL4 NOT NULL,
  "activity_player_apply_id" int4,
  "activity_message_id" int4,
  "preferential_form" varchar(32) COLLATE "default",
  "preferential_value" numeric(20,2),
  "preferential_audit" int4,
  CONSTRAINT "activity_player_preferential_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "activity_player_preferential" OWNER TO "postgres";

COMMENT ON TABLE "activity_player_preferential" IS '玩家优惠信息表--eagle';

COMMENT ON COLUMN "activity_player_preferential"."id" IS '主键';

COMMENT ON COLUMN "activity_player_preferential"."activity_player_apply_id" IS '活动申请id';

COMMENT ON COLUMN "activity_player_preferential"."activity_message_id" IS '活动信息id';

COMMENT ON COLUMN "activity_player_preferential"."preferential_form" IS '优惠形式';

COMMENT ON COLUMN "activity_player_preferential"."preferential_value" IS '优惠值';

COMMENT ON COLUMN "activity_player_preferential"."preferential_audit" IS '优惠稽核倍数';

---------------------------------活动优先级activity_priotity--------------------------------
CREATE TABLE IF NOT EXISTS "activity_priotity" (
  "id" SERIAL4 NOT NULL,
  "activity_message_id" int4,
  "priotity" int4,
  CONSTRAINT "activity_priotity_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "activity_priotity" OWNER TO "postgres";

COMMENT ON TABLE "activity_priotity" IS '活动优先级--eagle';

COMMENT ON COLUMN "activity_priotity"."id" IS '主键';

COMMENT ON COLUMN "activity_priotity"."activity_message_id" IS '活动信息ID';

COMMENT ON COLUMN "activity_priotity"."priotity" IS '优先级';


-------------------------------------------activity_rule活动规则表----------------------------------------------
CREATE TABLE IF NOT EXISTS "activity_rule" (
  "id" SERIAL4 NOT NULL,
  "activity_message_id" int4,
  "claim_period" varchar(32) COLLATE "default",
  "limit_number" int4,
  "effective_time" timestamp(6),
  "is_demand_first" bool,
  "is_designated_game" bool,
  "game_type" varchar(1000) COLLATE "default",
  "is_designated_rank" bool,
  "rank" varchar(1000) COLLATE "default",
  "is_exclusive" bool,
  "exclusive_activity" varchar(1000) COLLATE "default",
  "places_number" int4,
  "is_audit" bool,
  "participation_form" varchar(32) COLLATE "default",
  CONSTRAINT "activity_rule_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "activity_rule" OWNER TO "postgres";

COMMENT ON TABLE "activity_rule" IS '活动规则表--eagle';

COMMENT ON COLUMN "activity_rule"."id" IS '主键';

COMMENT ON COLUMN "activity_rule"."activity_message_id" IS '活动信息主键';

COMMENT ON COLUMN "activity_rule"."claim_period" IS '申领周期operation.claim_period(自然日,自然周,自然月,活动周期)';

COMMENT ON COLUMN "activity_rule"."limit_number" IS '限制次数,无限制时次数为0';

COMMENT ON COLUMN "activity_rule"."effective_time" IS '有效时间';

COMMENT ON COLUMN "activity_rule"."is_demand_first" IS '是否要求首冲';

COMMENT ON COLUMN "activity_rule"."is_designated_game" IS '是否指定游戏';

COMMENT ON COLUMN "activity_rule"."game_type" IS '参与游戏(all或者具体游戏分类,多个分类用逗号隔开)';

COMMENT ON COLUMN "activity_rule"."is_designated_rank" IS '是否指定层级';

COMMENT ON COLUMN "activity_rule"."rank" IS '参与层级(all或者具体层级多个层级用逗号隔开)';

COMMENT ON COLUMN "activity_rule"."is_exclusive" IS '是否设置不同享';

COMMENT ON COLUMN "activity_rule"."exclusive_activity" IS '不同享设置(多个活动逗号隔开)';

COMMENT ON COLUMN "activity_rule"."places_number" IS '优惠名额数量';

COMMENT ON COLUMN "activity_rule"."is_audit" IS '是否审核';

COMMENT ON COLUMN "activity_rule"."participation_form" IS '活动参与形式operation.activity_participation_form(存款,周期)';

--------------------------------------------------活动优惠关系表activity_preferential_relation--------------------------------------------------------
CREATE TABLE IF NOT EXISTS "activity_preferential_relation" (
  "id" SERIAL4 NOT NULL,
  "activity_message_id" int4,
  "preferential_code" varchar(32) COLLATE "default",
  "preferential_value" numeric(20,2),
  "order" int4,
  CONSTRAINT "activity_preferential_relation_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "activity_preferential_relation" OWNER TO "postgres";

COMMENT ON TABLE "activity_preferential_relation" IS '活动优惠关系表--eagle';

COMMENT ON COLUMN "activity_preferential_relation"."id" IS '主键';

COMMENT ON COLUMN "activity_preferential_relation"."activity_message_id" IS '活动id';

COMMENT ON COLUMN "activity_preferential_relation"."preferential_code" IS '优惠代码';

COMMENT ON COLUMN "activity_preferential_relation"."preferential_value" IS '满足优惠值';

COMMENT ON COLUMN "activity_preferential_relation"."order" IS '顺序';

--------------------------------------------------活动优惠方式关系表activity_way_relation--------------------------------------------------------
CREATE TABLE IF NOT EXISTS "activity_way_relation" (
  "id" SERIAL4 NOT NULL,
  "activity_message_id" int4,
  "preferential_form" varchar(32) COLLATE "default",
  "preferential_value" numeric(20,2),
  "preferential_audit" numeric(20,2),
  "order_column" int4,
  CONSTRAINT "activity_way_relation_pkey" PRIMARY KEY ("id")
)
WITH (OIDS=FALSE)
;

ALTER TABLE "activity_way_relation" OWNER TO "postgres";

COMMENT ON TABLE "activity_way_relation" IS '活动优惠方式关系表--eagle';

COMMENT ON COLUMN "activity_way_relation"."id" IS '主键';

COMMENT ON COLUMN "activity_way_relation"."activity_message_id" IS '活动id';

COMMENT ON COLUMN "activity_way_relation"."preferential_form" IS '优惠形式';

COMMENT ON COLUMN "activity_way_relation"."preferential_value" IS '满足优惠值';

COMMENT ON COLUMN "activity_way_relation"."preferential_audit" IS '优惠稽核倍数';

COMMENT ON COLUMN "activity_way_relation"."order_column" IS '顺序';
