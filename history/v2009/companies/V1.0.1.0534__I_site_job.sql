-- auto gen by george 2018-01-25 19:23:08
--添加site_job api游戏收藏、评分任务
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value")
select  '113', NULL, 'site_job_113', 'api游戏收藏任务', 'so.wwb.gamebox.service.master.site.job.ApiGameLogCollectJob', 'siteJob', '2', '1', '2', '4', NULL, NULL, NULL, NULL, NULL, NULL
where 113 not in(select id from site_job where id = 113);
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value")
select '114', NULL, 'site_job_114', 'api游戏评分任务', 'so.wwb.gamebox.service.master.site.job.ApiGameLogScoreJob', 'siteJob', '2', '1', '2', '4', NULL, NULL, NULL, NULL, NULL, NULL
where 114 not in(select id from site_job where id = 114);

INSERT INTO "site_job_plan" ("job_id", "site_id", "run_time", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value", "status", "enable_status", "start_time")
select '113', '1', now(), '2', '4', NULL, NULL, '1', NULL, '0', '1', '0', '1', NULL
where 113 not in(select job_id from site_job_plan where job_id = 113 and site_id = '1');
INSERT INTO "site_job_plan" ("job_id", "site_id", "run_time", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value", "status", "enable_status", "start_time")
select '114', '1', now(), '2', '4', NULL, NULL, '1', NULL, '0', '1', '0', '1', NULL
where 114 not in(select job_id from site_job_plan where job_id = 114 and site_id = '1');