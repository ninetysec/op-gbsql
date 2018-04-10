-- auto gen by linsen 2018-03-29 15:08:06
-- 买分额度监控任务 by younger
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code",
"is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
select '站点任务-买分额度监控任务', NULL, NULL, 'so.wwb.gamebox.service.boss.job.SiteJobParentJob', 'execute', 't', '1', '0 5/10 * * * ?', 't', '站点任务-分钟级定时触发', '2018-03-28 11:03:30', NULL, 'site-job-credit',
'f', 'f', '["site_job_017"]', 'java.lang.String[]', 'A', 'scheduler4Site' where not EXISTS (SELECT job_code FROM task_schedule where job_code='site-job-credit');

