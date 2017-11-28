-- auto gen by root 2016-10-11 21:53:12

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class") select 'API1扩展任务（用于注单详细）', NULL, NULL, 'so.wwb.gamebox.service.boss.ApiExtendJob', 'execute', 't', '1', '0 0/120 * * * ?', 't', 'API扩展任务（用于注单详细）', '2016-10-10 06:43:33.906', NULL, 'api-extend', 'f', 'f', '12', 'java.lang.Integer' where 'api-extend' not in (SELECT job_code FROM task_schedule WHERE job_code='api-extend');

