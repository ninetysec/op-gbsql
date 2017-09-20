-- auto gen by cherry 2017-09-20 20:56:35
INSERT INTO "site_job" ("id","prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value")
select   '103',NULL, 'site_job_103', '彩票汇总任务', 'so.wwb.gamebox.service.master.LotteryFfsscSummeryJob', 'siteJob', '2', '1', '2', '2', NULL, NULL, NULL, '1', '0', '1'
WHERE not EXISTS(SELECT id FROM site_job where sub_job_code = 'site_job_103');

update site_job set job_class='so.wwb.gamebox.service.master.LotteryOrderSummaryJob' where sub_job_code='site_job_103';

INSERT INTO  "lottery_gather_conf" ( "abbr_name", "name", "code", "type", "url", "method", "request_content_type", "response_content_type", "json_param","conf_type","check_next")
select  'auto', '极速pk10', 'jspk10', 'pk10', '', '', '', '', '','gather','false'
WHERE not EXISTS(SELECT id FROM lottery_gather_conf where code = 'jspk10');


--修改时间:170909
--删除版本v1057
--drop table IF  EXISTS lottery_summery_record;
--ALTER TABLE lottery_winning_record DROP COLUMN IF EXISTS open_code;

CREATE TABLE IF not EXISTS "lottery_summary_record" (
"id" serial4 NOT NULL PRIMARY KEY,
"site_id" int4,
"expect" varchar(32) ,
"code" varchar(32) ,
"create_time" timestamp(6),
"status" varchar(2) ,
"remark" text
);


COMMENT ON TABLE "lottery_summary_record" IS '彩票汇总记录表';

COMMENT ON COLUMN "lottery_summary_record"."id" IS '主键';

COMMENT ON COLUMN "lottery_summary_record"."site_id" IS '站点ID';

COMMENT ON COLUMN "lottery_summary_record"."expect" IS '开奖期数';

COMMENT ON COLUMN "lottery_summary_record"."code" IS '彩种代号';

COMMENT ON COLUMN "lottery_summary_record"."create_time" IS '入库时间';

COMMENT ON COLUMN "lottery_summary_record"."status" IS '状态';

COMMENT ON COLUMN "lottery_summary_record"."remark" IS '备注';

CREATE INDEX if NOT EXISTS fk_lottery_summary_record_code_expect ON lottery_summary_record USING btree (code,expect);


update lottery_gather_conf set abbr_name='auto' where abbr_name='ffc';

select redo_sqls($$
   ALTER TABLE lottery_result_kill ADD COLUMN kill_percent numeric(20,3);
$$);


select redo_sqls($$
   ALTER TABLE lottery_result_kill ADD COLUMN profit_percent numeric(20,3);
$$);


CREATE TABLE IF not EXISTS "lottery_result_record" (
"id" serial4 NOT NULL PRIMARY KEY,
"expect" varchar(32) ,
"code" varchar(32) ,
"record_type" varchar(32) ,
"open_code" varchar(128) ,
"create_time" timestamp(6),
"user_name" varchar(32) ,
"hash" varchar(50) ,
"remark" text,
CONSTRAINT unique_lottery_result_record UNIQUE (hash)
);

COMMENT ON TABLE "lottery_result_record" IS '开奖结果记录表';

COMMENT ON COLUMN "lottery_result_record"."id" IS '主键';

COMMENT ON COLUMN "lottery_result_record"."expect" IS '开奖期数';

COMMENT ON COLUMN "lottery_result_record"."code" IS '彩种代号';

COMMENT ON COLUMN "lottery_result_record"."record_type" IS '记录类型,0新增,1修改';

COMMENT ON COLUMN "lottery_result_record"."open_code" IS '开奖号码';

COMMENT ON COLUMN "lottery_result_record"."create_time" IS '入库时间';

COMMENT ON COLUMN "lottery_result_record"."user_name" IS '操作用户名称';

COMMENT ON COLUMN "lottery_result_record"."remark" IS '备注';

COMMENT ON COLUMN "lottery_result_record"."hash" IS '开奖结果hash';

CREATE INDEX if NOT EXISTS fk_lottery_result_record ON lottery_result_record USING btree (code,expect);
