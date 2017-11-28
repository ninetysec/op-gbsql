-- auto gen by admin 2016-11-20 16:09:17

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT 'apiId-3-mg-采集任务', NULL, NULL, 'so.wwb.gamebox.service.company.MgGatherRecordJob', 'execute', 't', '1', '0 0/5 * * * ?', 't', 'api3采集任务', '2015-11-02 16:51:16', NULL, 'api-3-MG-Gather', 't', 'f', '0', 'java.lang.Integer'
WHERE NOT EXISTS(SELECT job_code FROM task_schedule WHERE job_code='api-3-MG-Gather');


