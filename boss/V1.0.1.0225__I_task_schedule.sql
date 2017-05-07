-- auto gen by admin 2016-11-16 11:20:47

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT 'API1转账核对任务', NULL, NULL, 'so.wwb.gamebox.service.boss.ApiCheckTransferJob', 'execute', 't', '1', '0 0/5 * * * ?', 't', 'API转账核对任务', '2016-09-25 06:43:33.906', NULL, 'api-checktransfer', 'f', 'f', '0', 'java.lang.Integer'
where not EXISTS(SELECT id FROM task_schedule WHERE job_code='api-checktransfer');
