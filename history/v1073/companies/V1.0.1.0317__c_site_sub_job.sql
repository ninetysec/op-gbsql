-- auto gen by cherry 2017-06-27 16:15:35
CREATE TABLE IF not EXISTS "site_sub_job" (
"id" int4 NOT NULL PRIMARY KEY,
"prefix_job_id" int4,
"sub_job_code" varchar(32) COLLATE "default",
"sub_job_name" varchar(128) COLLATE "default",
"job_class" varchar(256) COLLATE "default",
"job_method" varchar(64) COLLATE "default",
"job_type" varchar(2) COLLATE "default",
"status" varchar(1) COLLATE "default",
"job_time_type" varchar(6) COLLATE "default",
"job_time_unit" varchar(6) COLLATE "default",
"fixed_month" int4,
"fixed_day" int4,
"fixed_hour" int4,
"fixed_minutes" int4,
"fixed_second" int4,
"period_value" varchar(6) COLLATE "default"
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "site_sub_job" IS '站点子任务表--younger';

COMMENT ON COLUMN "site_sub_job"."id" IS '主键';

COMMENT ON COLUMN "site_sub_job"."prefix_job_id" IS '前置任务ID';

COMMENT ON COLUMN "site_sub_job"."sub_job_code" IS '子任务代码';

COMMENT ON COLUMN "site_sub_job"."sub_job_name" IS '子任务名称';

COMMENT ON COLUMN "site_sub_job"."job_class" IS '调用执行类';

COMMENT ON COLUMN "site_sub_job"."job_method" IS '调用执行方法';

COMMENT ON COLUMN "site_sub_job"."job_type" IS '任务类型';

COMMENT ON COLUMN "site_sub_job"."status" IS '状态';

COMMENT ON COLUMN "site_sub_job"."job_time_type" IS '任务时间类型1固定2周期';

COMMENT ON COLUMN "site_sub_job"."job_time_unit" IS '固定/周期时间单位（秒、分、时、）日、月、周、年';

COMMENT ON COLUMN "site_sub_job"."fixed_month" IS '固定月份';

COMMENT ON COLUMN "site_sub_job"."fixed_day" IS '固定天数';

COMMENT ON COLUMN "site_sub_job"."fixed_hour" IS '固定小时';

COMMENT ON COLUMN "site_sub_job"."fixed_minutes" IS '固定分钟';

COMMENT ON COLUMN "site_sub_job"."fixed_second" IS '固定秒数';

COMMENT ON COLUMN "site_sub_job"."period_value" IS '周期时间间隔';

CREATE TABLE IF not EXISTS "site_job_plan" (
"id" SERIAL4 NOT NULL PRIMARY KEY,
"job_id" int4,
"site_id" int4,
"run_time" timestamp(6),
"job_time_type" varchar(6) COLLATE "default",
"job_time_unit" varchar(6) COLLATE "default",
"fixed_month" int4,
"fixed_day" int4,
"fixed_hour" int4,
"fixed_minutes" int4,
"fixed_second" int4,
"period_value" varchar(6) COLLATE "default",
"status" varchar(2) COLLATE "default",
"enable_status" varchar(10) COLLATE "default"
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "site_job_plan" IS '站点任务执行计划表--younger';

COMMENT ON COLUMN "site_job_plan"."id" IS '主键';

COMMENT ON COLUMN "site_job_plan"."job_id" IS '任务ID';

COMMENT ON COLUMN "site_job_plan"."site_id" IS '站点ID';

COMMENT ON COLUMN "site_job_plan"."run_time" IS '任务开始执行时间';

COMMENT ON COLUMN "site_job_plan"."job_time_type" IS '任务时间类型1固定2周期';

COMMENT ON COLUMN "site_job_plan"."job_time_unit" IS '固定/周期时间单位（秒、分、时、）日、月、周、年';

COMMENT ON COLUMN "site_job_plan"."fixed_month" IS '固定月份';

COMMENT ON COLUMN "site_job_plan"."fixed_day" IS '固定天数';

COMMENT ON COLUMN "site_job_plan"."fixed_hour" IS '固定小时';

COMMENT ON COLUMN "site_job_plan"."fixed_minutes" IS '固定分钟';

COMMENT ON COLUMN "site_job_plan"."fixed_second" IS '固定秒数';

COMMENT ON COLUMN "site_job_plan"."period_value" IS '周期时间间隔';

COMMENT ON COLUMN "site_job_plan"."status" IS '状态';

COMMENT ON COLUMN "site_job_plan"."enable_status" IS '启用状态';

CREATE TABLE IF not EXISTS "site_job_run_record" (
"id" SERIAL4 NOT NULL PRIMARY KEY,
"run_date" timestamp(6),
"job_id" int4,
"site_id" int4,
"end_time" timestamp(6),
"status" varchar(2) COLLATE "default",
"job_log" text COLLATE "default",
"operator_id" int4
)
WITH (OIDS=FALSE)
;

COMMENT ON TABLE "site_job_run_record" IS '站点任务执行记录表--younger';

COMMENT ON COLUMN "site_job_run_record"."id" IS '主键';

COMMENT ON COLUMN "site_job_run_record"."run_date" IS '运行时间';

COMMENT ON COLUMN "site_job_run_record"."job_id" IS '任务ID';

COMMENT ON COLUMN "site_job_run_record"."site_id" IS '站点ID';

COMMENT ON COLUMN "site_job_run_record"."end_time" IS '结束时间';

COMMENT ON COLUMN "site_job_run_record"."status" IS '状态';

COMMENT ON COLUMN "site_job_run_record"."job_log" IS '运行记录日志';

COMMENT ON COLUMN "site_job_run_record"."operator_id" IS '操作人ID';


drop view if EXISTS v_site_job_plan;
CREATE OR REPLACE VIEW "v_site_job_plan" AS
 SELECT a1.id,
    a1.job_id,
    a2.prefix_job_id,
    a2.sub_job_code,
    a2.sub_job_name,
    a3.sub_job_code AS prefix_job_code,
    a3.sub_job_name AS prefix_job_name,
    a2.job_class,
    a2.job_method,
    a1.site_id,
    a4.sys_user_id master_id,
    a4.parent_id center_id,
    a4.timezone timezone,
    a1.run_time,
    a1.job_time_type,
    a1.job_time_unit,
    a1.fixed_month,
    a1.fixed_day,
    a1.fixed_hour,
    a1.fixed_minutes,
    a1.fixed_second,
    a1.period_value,
    a1.status,
    a1.enable_status
   FROM ((site_job_plan a1
     LEFT JOIN site_sub_job a2 ON ((a1.job_id = a2.id)))
     LEFT JOIN site_sub_job a3 ON ((a2.prefix_job_id = a3.id))
		 LEFT JOIN sys_site a4 on a1.site_id=a4."id" );

