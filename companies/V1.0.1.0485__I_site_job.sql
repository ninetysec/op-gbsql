-- auto gen by george 2017-12-05 16:58:13
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value")
SELECT '18', '9', 'site_job_018', '代理返佣未出账单任务', 'so.wwb.gamebox.service.master.AgentRebateNoSettleJob', 'siteJob', '1', '0', '1', '4', NULL, NULL, '1', '0', '0', NULL
WHERE NOT EXISTS (SELECT id from site_job where id=18);

