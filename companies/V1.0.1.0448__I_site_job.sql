-- auto gen by cherry 2017-10-24 11:35:00
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name",
"job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit",
"fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value")
SELECT '110', NULL, 'site_job_110', '注单采集结果详细', 'so.wwb.gamebox.service.master.GameOrderDetailJob',
'siteJob', '2', '1', '2', '2', NULL, NULL, NULL, NULL, NULL, '8'
WHERE not EXISTS(SELECT id FROM site_job where sub_job_code='site_job_110');