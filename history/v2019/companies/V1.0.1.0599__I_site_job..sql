-- auto gen by linsen 2018-04-16 16:20:08
-- 优惠周期结算任务 by kobe
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value")
SELECT '21', NULL, 'site_job_021', '优惠周期结算任务', 'so.wwb.gamebox.service.master.PreferentialSettleJob', 'siteJob', '2', '1', '2', '3', NULL, NULL, '1', NULL, NULL, '2'
WHERE 21 NOT IN (SELECT ID FROM site_job WHERE ID = 21);
