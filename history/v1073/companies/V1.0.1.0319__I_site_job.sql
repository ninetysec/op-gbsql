-- auto gen by cherry 2017-06-27 17:03:23
CREATE TABLE IF not EXISTS "site_job" (
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

COMMENT ON TABLE "site_job" IS '站点任务表--younger';

COMMENT ON COLUMN "site_job"."id" IS '主键';

COMMENT ON COLUMN "site_job"."prefix_job_id" IS '前置任务ID';

COMMENT ON COLUMN "site_job"."sub_job_code" IS '子任务代码';

COMMENT ON COLUMN "site_job"."sub_job_name" IS '子任务名称';

COMMENT ON COLUMN "site_job"."job_class" IS '调用执行类';

COMMENT ON COLUMN "site_job"."job_method" IS '调用执行方法';

COMMENT ON COLUMN "site_job"."job_type" IS '任务类型';

COMMENT ON COLUMN "site_job"."status" IS '状态';

COMMENT ON COLUMN "site_job"."job_time_type" IS '任务时间类型1固定2周期';

COMMENT ON COLUMN "site_job"."job_time_unit" IS '固定/周期时间单位（秒、分、时、）日、月、周、年';

COMMENT ON COLUMN "site_job"."fixed_month" IS '固定月份';

COMMENT ON COLUMN "site_job"."fixed_day" IS '固定天数';

COMMENT ON COLUMN "site_job"."fixed_hour" IS '固定小时';

COMMENT ON COLUMN "site_job"."fixed_minutes" IS '固定分钟';

COMMENT ON COLUMN "site_job"."fixed_second" IS '固定秒数';

COMMENT ON COLUMN "site_job"."period_value" IS '周期时间间隔';

DELETE FROM site_job;
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('1', NULL, 'site_job_001', '收款账户清零任务', 'so.wwb.gamebox.service.master.AccountClearJob', 'siteJob', '2', '1', '1', '4', NULL, NULL, '1', '0', '0', NULL);
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('2', NULL, 'site_job_002', '优惠周期任务', 'so.wwb.gamebox.service.master.PreferentialProcedureJob', 'siteJob', '2', '1', '2', '3', NULL, NULL, '1', NULL, NULL, '1');
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('3', NULL, 'site_job_003', '推荐奖励周期任务', 'so.wwb.gamebox.service.master.PlayerRecommendAwardJob', 'siteJob', '2', '1', '1', '4', NULL, NULL, '1', '0', '0', NULL);
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('4', NULL, 'site_job_004', '返水未出账单任务', 'so.wwb.gamebox.service.master.RakebakeNotSettledProcedureJob', 'siteJob', '2', '1', '1', '4', NULL, NULL, '1', '0', '0', NULL);
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('5', NULL, 'site_job_005', '返水账单任务', 'so.wwb.gamebox.service.master.RakebakeProcedureJob', 'siteJob', '2', '1', '1', '4', NULL, NULL, '1', '0', '0', NULL);
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('6', '9', 'site_job_006', '返佣周期任务', 'so.wwb.gamebox.service.master.RebateProcedureJob', 'siteJob', '2', '1', '1', '5', NULL, '3', '1', '0', '0', NULL);
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('7', NULL, 'site_job_007', '站点统计返水', 'so.wwb.gamebox.service.stat.SiteRakebackStatProcedureJobBySiteId', 'siteJob', '1', '1', '1', '4', NULL, NULL, '1', '0', '0', NULL);
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('8', '7', 'site_job_008', '站点统计返佣', 'so.wwb.gamebox.service.stat.SiteRebateStatProcedureJobBySiteId', 'siteJob', '1', '1', '1', '4', NULL, NULL, '1', '0', '0', NULL);
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('9', NULL, 'site_job_009', '站点经营报表', 'so.wwb.gamebox.service.stat.OperationProcedureJobBySiteId', 'siteJob', '1', '1', '1', '4', NULL, NULL, '1', '0', '0', NULL);
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('10', '9', 'site_job_010', '总代占成任务', 'so.wwb.gamebox.service.master.AgentOccupyProcedureJob', 'siteJob', '2', '1', '1', '5', NULL, '3', '1', '0', '0', NULL);
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('11', '9', 'site_job_011', '站点帐务(结算)账单', 'so.wwb.gamebox.service.stat.StationBillProcedureJob', 'siteJob', '2', '1', '1', '5', NULL, '3', '1', '0', '0', NULL);
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('12', NULL, 'site_job_012', '总代帐务(结算)账单', 'so.wwb.gamebox.service.stat.TopAgentBillProcedureJob', 'siteJob', '2', '1', '1', '5', NULL, '3', '1', '0', '0', NULL);
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('13', '9', 'site_job_013', '运营概况任务', 'so.wwb.gamebox.service.stat.OperationProfileProcedureJobBySiteId', 'siteJob', '1', '1', '1', '4', NULL, NULL, '1', '0', '0', NULL);
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('14', NULL, 'site_job_014', '代理新进任务', 'so.wwb.gamebox.service.master.AnalyzePlayerJob', 'siteJob', '1', '1', '1', '4', NULL, NULL, '1', '0', '0', NULL);
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('15', '9', 'site_job_015', '代理返佣任务', 'so.wwb.gamebox.service.master.AgentRebateJob', 'siteJob', '1', '1', '1', '5', NULL, '3', '1', '0', '0', NULL);
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('16', NULL, 'site_job_016', '统计结算账单盈亏', 'so.wwb.gamebox.service.master.StationProfitLossJob', 'siteJob', '1', '1', '1', '5', NULL, '3', '1', '0', '0', NULL);


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
     LEFT JOIN site_job a2 ON ((a1.job_id = a2.id)))
     LEFT JOIN site_job a3 ON ((a2.prefix_job_id = a3.id))
		 LEFT JOIN sys_site a4 on a1.site_id=a4."id" );