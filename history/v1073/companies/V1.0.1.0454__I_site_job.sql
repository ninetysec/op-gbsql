-- auto gen by cherry 2017-10-26 16:24:56
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value")
SELECT '17', NULL, 'site_job_017', '站点盈利预警任务', 'so.wwb.gamebox.service.master.QuotaWarningJob', 'siteJob', '2', '1', '2', '3', NULL, NULL, '1', NULL, NULL, '1'
WHERE not EXISTS (SELECT id from site_job where id=17);

