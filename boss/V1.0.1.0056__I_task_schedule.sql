-- auto gen by admin 2016-05-20 17:41:36
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
 SELECT '统计任务-统计站点返佣', NULL, NULL, 'so.wwb.gamebox.service.stat.SiteRebateStatProcedureJob', 'execute', 't', '1', '0 0 18 * * ?', 't', '全站任务', '2015-11-02 16:51:16', NULL, 'all-006', 't', 'f', NULL, NULL
WHERE NOT EXISTS(SELECT job_code FROM task_schedule WHERE job_code='all-006');

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT '统计任务-统计站点返水', NULL, NULL, 'so.wwb.gamebox.service.stat.SiteRakebackStatProcedureJob', 'execute', 't', '1', '0 0 17 * * ?', 't', '全站任务', '2015-11-02 16:51:16', NULL, 'all-007', 't', 'f', NULL, NULL
WHERE NOT EXISTS(SELECT job_code FROM task_schedule WHERE job_code='all-007');


