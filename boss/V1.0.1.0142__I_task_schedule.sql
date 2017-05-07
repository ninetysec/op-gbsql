-- auto gen by cherry 2016-09-24 17:16:58
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT 'apiId-17-sa-下单记录', NULL, NULL, 'so.wwb.gamebox.service.company.PlayerGameOrderFetchJob', 'execute', 't', '2', '0 0/4 * * * ?', 't', 'api任务', now(), NULL, 'api-17-I', 'f', 'f', '17', 'java.lang.Integer'
where not EXISTS(SELECT id FROM task_schedule WHERE job_code='api-17-I');

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT 'apiId-17-sa-修改下单记录', NULL, NULL, 'so.wwb.gamebox.service.company.PlayerGameOrderModifierJob', 'execute', 't', '2', '0 0/10 * * * ?', 't', 'api任务', now(), NULL, 'api-17-M', 'f', 'f', '17', 'java.lang.Integer'
where not EXISTS(SELECT id FROM task_schedule WHERE job_code='api-17-M')
