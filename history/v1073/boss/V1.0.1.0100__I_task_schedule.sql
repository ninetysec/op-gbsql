-- auto gen by cherry 2016-08-15 15:58:44
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT 'apiId-15-hb-下单记录', NULL, NULL, 'so.wwb.gamebox.service.company.PlayerGameOrderFetchJob', 'execute', 't', '2', '0 0/4 * * * ?', 't', 'api任务', now(), NULL, 'api-15-I', 'f', 'f', '15', 'java.lang.Integer'
where not EXISTS (SELECT id from task_schedule where job_code='api-15-I');

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT 'apiId-15-hb-修改下单记录', NULL, NULL, 'so.wwb.gamebox.service.company.PlayerGameOrderModifierJob', 'execute', 't', '2', '0 0/10 * * * ?', 't', 'api任务', now(), NULL, 'api-15-M', 'f', 'f', '15', 'java.lang.Integer'
WHERE not EXISTS(SELECT id from task_schedule where job_code='api-15-M');