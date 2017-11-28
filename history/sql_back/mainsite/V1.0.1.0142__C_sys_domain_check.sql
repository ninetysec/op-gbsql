-- auto gen by cheery 2015-12-10 09:30:27
CREATE TABLE IF NOT EXISTS "sys_domain_check" (
"id" SERIAL4 PRIMARY KEY NOT NULL,
"site_id" int4 NOT NULL,
"sys_domain_id" int4 NOT NULL,
"content_type" varchar(32) COLLATE "default" NOT NULL,
"publish_time" timestamp(6),
"publish_user_id" int4 NOT NULL,
"publish_user_name" varchar(32) COLLATE "default",
"check_user_id" int4 NOT NULL,
"check_status" varchar(32) COLLATE "default",
"check_time" timestamp(6),
"reason_title" varchar(128) COLLATE "default",
"reason_content" varchar(1000) COLLATE "default",
"domain" varchar(100) COLLATE "default"
)
WITH (OIDS=FALSE)
;
COMMENT ON COLUMN "sys_domain_check"."site_id" IS '站点id';
COMMENT ON COLUMN "sys_domain_check"."sys_domain_id" IS '域名id';
COMMENT ON COLUMN "sys_domain_check"."content_type" IS '请求操作(1绑定域名,4解除绑定)';
COMMENT ON COLUMN "sys_domain_check"."publish_time" IS '提交时间';
COMMENT ON COLUMN "sys_domain_check"."publish_user_id" IS '提交人ID';
COMMENT ON COLUMN "sys_domain_check"."publish_user_name" IS '提交人用户名';
COMMENT ON COLUMN "sys_domain_check"."check_user_id" IS '审核人Id';
COMMENT ON COLUMN "sys_domain_check"."check_status" IS '审核状态common.check_status(通过,失败,待审核)';
COMMENT ON COLUMN "sys_domain_check"."check_time" IS '审核时间';
COMMENT ON COLUMN "sys_domain_check"."reason_title" IS '失败原因标题';
COMMENT ON COLUMN "sys_domain_check"."reason_content" IS '失败原因内容';
COMMENT ON COLUMN "sys_domain_check"."domain" IS '域名';

ALTER TABLE "site_confine_ip" ALTER COLUMN "remark" TYPE varchar(250) COLLATE "default";

ALTER TABLE "site_confine_area" ALTER COLUMN "remark" TYPE varchar(250) COLLATE "default";

ALTER TABLE "sys_domain" DROP COLUMN  IF EXISTS handle_status;
  select redo_sqls($$
    ALTER TABLE "sys_domain_check"  ADD COLUMN "code" varchar(100);
		ALTER TABLE "sys_domain"  ADD COLUMN code varchar(100);
  $$);

COMMENT ON COLUMN "sys_domain"."code" IS '识别码，跟域名审核表code一致';
COMMENT ON COLUMN "sys_domain_check"."code" IS '识别码，跟域名表code一致';

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
 SELECT 'setting', 'visit', 'visit.management.center', 'false', 'true', NULL, '是否开启允许访问管理中心的IP', NULL, 'f', '1'
   WHERE 'visit.management.center' not in (SELECT param_code from sys_param where module = 'setting' and param_type = 'visit');
