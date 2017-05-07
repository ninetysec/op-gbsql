-- auto gen by cheery 2015-11-27 15:30:54
--创建内容审核表
CREATE TABLE IF NOT EXISTS "site_content" (
  "id" SERIAL4 NOT NULL ,
  "site_id" int4,
  "pending_check" int,
  "audit_check" int,
  "last_publish_time" timestamp,
  PRIMARY KEY ("id")
);
COMMENT ON COLUMN "site_content"."id" IS '主键';
COMMENT ON COLUMN "site_content"."site_id" IS '站点';
COMMENT ON COLUMN "site_content"."pending_check" IS '待审核数';
COMMENT ON COLUMN "site_content"."audit_check" IS '已审核数';
COMMENT ON COLUMN "site_content"."last_publish_time" IS '最新提交时间';
COMMENT ON TABLE site_content IS '内容审核表--river';

--创建内容审核记录表
CREATE TABLE IF NOT EXISTS "site_content_check" (
  "id" SERIAL4 NOT NULL,
  "site_id" int4,
  "content_type" varchar(32),
  "source_id" int4,
  "content_name" varchar(128),
  "publish_time" timestamp,
  "check_user_id" int4,
  "check_status" varchar(32),
  "check_time" timestamp,
  "reason_title" varchar(128),
  "reason_content" varchar(1000),
  PRIMARY KEY ("id")
);
COMMENT ON COLUMN "site_content_check"."id" IS '主键';
COMMENT ON COLUMN "site_content_check"."site_id" IS '站点';
COMMENT ON COLUMN "site_content_check"."content_type" IS '内容类型content.content_type(文案,logo,优惠)';
COMMENT ON COLUMN "site_content_check"."source_id" IS '源内容主键';
COMMENT ON COLUMN "site_content_check"."content_name" IS '内容名称(优先保存运营商主语言版本的内容名称,若为空则保存站长主语言版本的内容名称)';
COMMENT ON COLUMN "site_content_check"."publish_time" IS '提交时间';
COMMENT ON COLUMN "site_content_check"."check_user_id" IS '审核人';
COMMENT ON COLUMN "site_content_check"."check_status" IS '审核状态common.check_status(通过,失败,待审核)';
COMMENT ON COLUMN "site_content_check"."check_time" IS '审核时间';
COMMENT ON COLUMN "site_content_check"."reason_title" IS '失败原因标题';
COMMENT ON COLUMN "site_content_check"."reason_content" IS '失败原因内容';
COMMENT ON TABLE site_content_check IS '内容审核记录表--river';

--创建内容审核视图
CREATE OR REPLACE VIEW v_site_content AS
  SELECT a.id,
    a.site_id,
    a.pending_check,
    a.audit_check,
    a.last_publish_time,
    b.name AS site_name,
    c.username AS master_name,
    b.logo_path,
    b.site_classify_key,
    b.main_language,
    c.user_type
  FROM site_content a,
    sys_site b,
    sys_user c
  WHERE a.site_id = b.id AND b.sys_user_id = c.id;
COMMENT ON VIEW v_site_content IS '内容审核视图--river';

--创建内容审核记录视图
CREATE OR REPLACE VIEW v_site_content_check AS
  SELECT a.id,
    a.site_id,
    a.content_type,
    a.content_name,
    a.publish_time,
    a.check_user_id,
    a.check_status,
    a.check_time,
    a.reason_title,
    a.reason_content,
    a.source_id,
    b.username master_name,
    b.user_type,
    c.name AS site_name,
    c.logo_path,
    c.site_classify_key,
    c.main_language
  FROM site_content_check a,
    sys_user b,
    sys_site c
  WHERE a.site_id = c.id AND c.sys_user_id = b.id;
COMMENT ON VIEW v_site_content_check IS '内容审核记录视图--river';

--添加视图说明
COMMENT ON VIEW v_site_api_type_relation
IS '站点API类型和API视图--river';

--修改视图添加字段
DROP VIEW IF EXISTS v_site_api;
CREATE OR REPLACE VIEW v_site_api AS
  SELECT t.id,
    t.site_id,
    t.status,
    ( SELECT count(1) AS count
      FROM site_game a
      WHERE a.api_id = t.id) AS game_count,
    '0' AS player_count,
    t.api_id
  FROM site_api t;
COMMENT ON VIEW v_site_api IS '站点API视图--river';

--修改视图添加字段
DROP VIEW IF EXISTS v_site_api_type;
CREATE OR REPLACE VIEW v_site_api_type AS
  SELECT t.id,
    t.site_id,
    ( SELECT count(1) AS apicount
      FROM site_api_type_relation a
      WHERE a.api_type_id = t.id) AS api_count,
    0 AS player_count,
    t.order_num,
    t.status,
    t.api_type_id
  FROM site_api_type t
  ORDER BY t.status DESC, t.order_num;
COMMENT ON VIEW v_site_api_type IS '站点API类型视图--river';