-- auto gen by cherry 2016-12-23 10:57:43
create table IF NOT EXISTS site_sub_job(
  id SERIAL4 NOT NULL PRIMARY KEY ,

  prefix_job_id INTEGER,

  sub_job_code CHARACTER VARYING(32),

  sub_job_name CHARACTER VARYING(128),

  job_class CHARACTER VARYING(256),

  job_method CHARACTER VARYING(64),

  job_type CHARACTER VARYING(2),

  status CHARACTER VARYING(1)

);

COMMENT ON TABLE site_sub_job IS '站点子任务表--younger';

COMMENT ON COLUMN site_sub_job.id IS '主键';

COMMENT ON COLUMN site_sub_job.prefix_job_id IS '前置任务ID';

COMMENT ON COLUMN site_sub_job.sub_job_code IS '子任务代码';

COMMENT ON COLUMN site_sub_job.sub_job_name IS '子任务名称';

COMMENT ON COLUMN site_sub_job.job_class IS '调用执行类';

COMMENT ON COLUMN site_sub_job.job_method IS '调用执行方法';

COMMENT ON COLUMN site_sub_job.job_type IS '任务类型';

COMMENT ON COLUMN site_sub_job.status IS '状态';

create table IF NOT EXISTS site_job_plan(

  id SERIAL4 NOT NULL PRIMARY KEY ,

  job_id INTEGER,

  site_id INTEGER,

  timezone CHARACTER VARYING(16),

  run_time TIMESTAMP,

  job_time_type CHARACTER VARYING(6),

  job_time_unit CHARACTER VARYING(6),

  fixed_month int4,

  fixed_day int4,

  fixed_hour int4,

  fixed_minutes int4,

  fixed_second int4,

  period_value CHARACTER VARYING(6),

  status CHARACTER VARYING(2)

);

COMMENT ON TABLE site_job_plan IS '站点任务执行计划表--younger';

COMMENT ON COLUMN site_job_plan.id IS '主键';

COMMENT ON COLUMN site_job_plan.job_id IS '任务ID';

COMMENT ON COLUMN site_job_plan.site_id IS '站点ID';

COMMENT ON COLUMN site_job_plan.timezone IS '时区';

COMMENT ON COLUMN site_job_plan.run_time IS '任务开始执行时间';

COMMENT ON COLUMN site_job_plan.job_time_type IS '任务时间类型1固定2周期';

COMMENT ON COLUMN site_job_plan.job_time_unit IS '固定/周期时间单位（秒、分、时、）日、月、周、年';

COMMENT ON COLUMN site_job_plan.fixed_month IS '固定月份';

COMMENT ON COLUMN site_job_plan.fixed_day IS '固定天数';

COMMENT ON COLUMN site_job_plan.fixed_hour IS '固定小时';

COMMENT ON COLUMN site_job_plan.fixed_minutes IS '固定分钟';

COMMENT ON COLUMN site_job_plan.fixed_second IS '固定秒数';

COMMENT ON COLUMN site_job_plan.period_value IS '周期时间间隔';

COMMENT ON COLUMN site_job_plan.status IS '状态';

create table IF NOT EXISTS site_Job_run_record(

  id SERIAL4 NOT NULL PRIMARY KEY ,

  run_date TIMESTAMP,

  job_id INTEGER,

  site_id INTEGER,

	start_time TIMESTAMP,

  end_time TIMESTAMP,

  status CHARACTER VARYING(2),

  job_log TEXT
);

COMMENT ON TABLE site_Job_run_record IS '站点任务执行记录表--younger';

COMMENT ON COLUMN site_Job_run_record.id IS '主键';

COMMENT ON COLUMN site_Job_run_record.run_date IS '运行时间';

COMMENT ON COLUMN site_Job_run_record.job_id IS '任务ID';

COMMENT ON COLUMN site_Job_run_record.site_id IS '站点ID';

COMMENT ON COLUMN site_Job_run_record.start_time IS '开始时间';

COMMENT ON COLUMN site_Job_run_record.end_time IS '结束时间';

COMMENT ON COLUMN site_Job_run_record.status IS '状态';

COMMENT ON COLUMN site_Job_run_record.job_log IS '运行记录日志';

DROP view if EXISTS v_site_job_plan;

CREATE OR REPLACE VIEW "v_site_job_plan" AS

 SELECT a1.id,

    a1.job_id,

    a2.prefix_job_id,

    a2.sub_job_code,

    a2.sub_job_name,

    a3.sub_job_code prefix_job_code,

    a3.sub_job_name prefix_job_name,

    a2.job_class,

    a2.job_method,

    a1.site_id,

    a1.timezone,

    a1.run_time,

    a1.job_time_type,

    a1.job_time_unit,

    a1.fixed_month,

    a1.fixed_day,

    a1.fixed_hour,

    a1.fixed_minutes,

    a1.fixed_second,

    a1.period_value,

    a1.status

   FROM (site_job_plan a1

     LEFT JOIN site_sub_job a2 ON ((a1.job_id = a2.id))

     LEFT JOIN site_sub_job a3 on a2.prefix_job_id=a3.id);


INSERT INTO sys_resource ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")

SELECT '516', '站点任务', 'vSiteJobPlan/list.html', '站点任务', '5', NULL, '16', 'boss', 'maintenance:siteJob', '1', NULL, 'f', 't', 't'

WHERE NOT EXISTS(SELECT id from sys_resource where id='516');

INSERT INTO "task_schedule" ("id", "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")

SELECT '711', '东八区站点任务', NULL, NULL, 'so.wwb.gamebox.service.boss.SiteTaskByTimeAreaJob', 'execute', 't', '1', '0 0 0/1 * * ?', 'f', '东八区站点任务', '2016-12-12 21:03:30', NULL, 'site_sub_job_001', 'f', 'f', 'GMT+08:00', 'java.lang.String' WHERE 711 NOT IN(SELECT id FROM task_schedule WHERE id=711);

INSERT INTO "task_schedule" ("id", "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")

SELECT '712', '西四区站点任务', NULL, NULL, 'so.wwb.gamebox.service.boss.SiteTaskByTimeAreaJob', 'execute', 't', '2', '0 0 0/1 * * ?', 'f', '西四区站点任务', '2016-12-12 21:10:41', NULL, 'site_sub_job_002', 'f', 'f', 'GMT-04:00', 'java.lang.String' WHERE 712 NOT IN(SELECT id FROM task_schedule WHERE id=712);


INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status")

SELECT '1', NULL, 'site_job_001', '返水基础任务', 'so.wwb.gamebox.service.master.RakebackApiBaseProcedureJob', 'execute', '2', '1' where 1 not in (select id from site_sub_job where id=1);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status")

SELECT '2', NULL, 'site_job_002', '收款账户清零任务', 'so.wwb.gamebox.service.master.AccountClearJob', 'execute', '2', '1' where 2 not in (select id from site_sub_job where id=2);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status")

SELECT '3', NULL, 'site_job_003', '优惠计算', 'so.wwb.gamebox.service.master.PreferentialProcedureJob', 'execute', '2', '1' where 3 not in (select id from site_sub_job where id=3);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status")

SELECT '4', NULL, 'site_job_004', '推荐任务', 'so.wwb.gamebox.service.master.PlayerRecommendAwardJob', 'execute', '2', '1' where 4 not in (select id from site_sub_job where id=4);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status")

SELECT '5', '1', 'site_job_005', '返水未出账单任务', 'so.wwb.gamebox.service.master.RakebakeNotSettledProcedureJob', 'execute', '2', '1' where 5 not in (select id from site_sub_job where id=5);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status")

SELECT '6', '1', 'site_job_006', '返水任务', 'so.wwb.gamebox.service.master.RakebakeProcedureJob', 'execute', '2', '1' where 6 not in (select id from site_sub_job where id=6);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status")

SELECT '7', '1', 'site_job_007', '返佣未出账单任务', 'so.wwb.gamebox.service.master.RebateNotSettledProcedureJob', 'execute', '2', '1' where 7 not in (select id from site_sub_job where id=7);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status")

SELECT '8', '1', 'site_job_008', '返佣任务', 'so.wwb.gamebox.service.master.RebateProcedureJob', 'execute', '2', '1' where 8 not in (select id from site_sub_job where id=8);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status")

SELECT '9', '1', 'site_job_009', '站点返水任务', 'so.wwb.gamebox.service.stat.SiteRakebackStatProcedureJobBySiteId', 'execute', '1', '1' where 9 not in (select id from site_sub_job where id=9);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status")

SELECT '10', '1', 'site_job_010', '站点返佣任务', 'so.wwb.gamebox.service.stat.SiteRebateStatProcedureJobBySiteId', 'execute', '1', '1' where 10 not in (select id from site_sub_job where id=10);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status")

SELECT '11', '1', 'site_job_011', '经营报表任务', 'so.wwb.gamebox.service.stat.OperationProcedureJobBySiteId', 'execute', '1', '1' where 11 not in (select id from site_sub_job where id=11);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status")

SELECT '12', '1', 'site_job_012', '总代占成任务', 'so.wwb.gamebox.service.master.AgentOccupyProcedureJob', 'execute', '2', '1' where 12 not in (select id from site_sub_job where id=12);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status")

SELECT '13', NULL, 'site_job_013', '站务账单', 'so.wwb.gamebox.service.stat.StationBillProcedureJob', 'execute', '2', '1' where 13 not in (select id from site_sub_job where id=13);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status")

SELECT '14', NULL, 'site_job_014', '总代站务账单任务', 'so.wwb.gamebox.service.stat.TopAgentBillProcedureJob', 'execute', '2', '1' where 14 not in (select id from site_sub_job where id=14);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status")

SELECT '15', '11', 'site_job_015', '运营概况任务', 'so.wwb.gamebox.service.stat.OperationProfileProcedureJobBySiteId', 'execute', '1', '1' where 15 not in (select id from site_sub_job where id=15);
