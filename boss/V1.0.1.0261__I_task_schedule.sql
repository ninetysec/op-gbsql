-- auto gen by admin 2016-12-16 16:59:44


INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT 'apiId-7-og-游戏结果记录', NULL, NULL, 'so.wwb.gamebox.service.company.PlayerGameOrderResultJob', 'execute', 't', '2', '0 2/5 * * * ?', 't', 'api任务', now(), NULL, 'api-7-G', 'f', 'f', '7', 'java.lang.Integer'
where not EXISTS(SELECT id FROM task_schedule WHERE job_code='api-7-G')
