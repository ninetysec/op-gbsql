-- auto gen by cherry 2017-03-03 16:25:00
select redo_sqls($$

alter table site_sub_job add COLUMN job_time_type CHARACTER VARYING(6);

  alter table site_sub_job add COLUMN job_time_unit CHARACTER VARYING(6);

  alter table site_sub_job add COLUMN fixed_month int4;

  alter table site_sub_job add COLUMN fixed_day int4;

  alter table site_sub_job add COLUMN fixed_hour int4;

  alter table site_sub_job add COLUMN fixed_minutes int4;

  alter table site_sub_job add COLUMN fixed_second int4;

  alter table site_sub_job add COLUMN period_value CHARACTER VARYING(6);

$$);



COMMENT ON COLUMN site_sub_job.job_time_type IS '任务时间类型1固定2周期';

COMMENT ON COLUMN site_sub_job.job_time_unit IS '固定/周期时间单位（秒、分、时、）日、月、周、年';

COMMENT ON COLUMN site_sub_job.fixed_month IS '固定月份';

COMMENT ON COLUMN site_sub_job.fixed_day IS '固定天数';

COMMENT ON COLUMN site_sub_job.fixed_hour IS '固定小时';

COMMENT ON COLUMN site_sub_job.fixed_minutes IS '固定分钟';

COMMENT ON COLUMN site_sub_job.fixed_second IS '固定秒数';

COMMENT ON COLUMN site_sub_job.period_value IS '周期时间间隔';





delete from site_sub_job;

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('2', NULL, 'site_job_002', '收款账户清零任务', 'so.wwb.gamebox.service.master.AccountClearJob', 'siteJob', '2', '1', '1', '4', NULL, NULL, '1', '0', '0', NULL);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('3', NULL, 'site_job_003', '优惠周期任务', 'so.wwb.gamebox.service.master.PreferentialProcedureJob', 'siteJob', '2', '1', '2', '3', NULL, NULL, '1', '0', '0', '1');

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('4', NULL, 'site_job_004', '推荐奖励周期任务', 'so.wwb.gamebox.service.master.PlayerRecommendAwardJob', 'siteJob', '2', '1', '1', '4', NULL, NULL, '1', '0', '0', NULL);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('5', NULL, 'site_job_005', '返水未出账单任务', 'so.wwb.gamebox.service.master.RakebakeNotSettledProcedureJob', 'siteJob', '2', '1', '1', '4', NULL, NULL, '1', '0', '0', NULL);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('6', NULL, 'site_job_006', '返水账单任务', 'so.wwb.gamebox.service.master.RakebakeProcedureJob', 'siteJob', '2', '1', '1', '4', NULL, NULL, '1', '0', '0', NULL);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('7', '11', 'site_job_007', '返佣未出账单任务', 'so.wwb.gamebox.service.master.RebateNotSettledProcedureJob', 'siteJob', '2', '1', '1', '4', NULL, NULL, '1', '20', '0', NULL);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('8', '11', 'site_job_008', '返佣周期任务', 'so.wwb.gamebox.service.master.RebateProcedureJob', 'siteJob', '2', '1', '1', '4', NULL, NULL, '1', '20', '0', NULL);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('9', NULL, 'site_job_009', '站点统计返水', 'so.wwb.gamebox.service.stat.SiteRakebackStatProcedureJobBySiteId', 'siteJob', '1', '1', '1', '4', NULL, NULL, '1', '0', '0', NULL);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('10', '8', 'site_job_010', '站点统计返佣', 'so.wwb.gamebox.service.stat.SiteRebateStatProcedureJobBySiteId', 'siteJob', '1', '1', '1', '4', NULL, NULL, '1', '20', '0', NULL);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('11', NULL, 'site_job_011', '站点经营报表', 'so.wwb.gamebox.service.stat.OperationProcedureJobBySiteId', 'siteJob', '1', '1', '1', '4', NULL, NULL, '1', '0', '0', NULL);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('12', NULL, 'site_job_012', '总代占成任务', 'so.wwb.gamebox.service.master.AgentOccupyProcedureJob', 'siteJob', '2', '1', '1', '4', NULL, NULL, '1', '0', '0', NULL);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('13', NULL, 'site_job_013', '站点帐务(结算)账单', 'so.wwb.gamebox.service.stat.StationBillProcedureJob', 'siteJob', '2', '1', '1', '5', NULL, '2', '1', '0', '0', NULL);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('14', NULL, 'site_job_014', '总代帐务(结算)账单', 'so.wwb.gamebox.service.stat.TopAgentBillProcedureJob', 'siteJob', '2', '1', '1', '5', NULL, '2', '1', '0', '0', NULL);

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('15', '11', 'site_job_015', '运营概况任务', 'so.wwb.gamebox.service.stat.OperationProfileProcedureJobBySiteId', 'siteJob', '1', '1', '2', '3', NULL, NULL, '1', '20', '0', '1');

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value") VALUES ('16', NULL, 'site_job_016', '代理新进任务', 'so.wwb.gamebox.service.master.AnalyzePlayerJob', 'siteJob', '1', '1', '1', '4', NULL, NULL, '1', '0', '0', NULL);