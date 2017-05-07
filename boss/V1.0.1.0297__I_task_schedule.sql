-- auto gen by cherry 2017-02-25 14:23:04
DELETE from task_schedule where job_code in ('site_sub_job_001','site_sub_job_002');

INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT  '东八区站点任务', NULL, NULL, 'so.wwb.gamebox.service.boss.SiteTaskByTimeAreaJob', 'execute', 't', '2', '0 0 0/1 * * ?', 'f', '东八区站点任务', '2016-12-12 21:03:30', NULL, 'site_sub_job_001', 'f', 'f', 'GMT+08:00', 'java.lang.String'
WHERE 'site_sub_job_001' NOT IN(SELECT job_code FROM task_schedule WHERE job_code='site_sub_job_001');

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT '西四区站点任务', NULL, NULL, 'so.wwb.gamebox.service.boss.SiteTaskByTimeAreaJob', 'execute', 't', '2', '0 0 0/1 * * ?', 'f', '西四区站点任务', '2016-12-12 21:10:41', NULL, 'site_sub_job_002', 'f', 'f', 'GMT-04:00', 'java.lang.String'
WHERE 'site_sub_job_002' NOT IN(SELECT job_code FROM task_schedule WHERE job_code='site_sub_job_002');