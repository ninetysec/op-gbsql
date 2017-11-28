-- auto gen by admin 2017-03-17 21:08:16
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT 'MQ重发任务', NULL, NULL, 'so.wwb.gamebox.service.boss.MqExceptionMsgJob', 'execute', 't', '1', '0 0/１ * * * ?', 't', 'MQ重发任务', '2016-09-25 06:43:33.906', NULL, 'MqExceptionMsgReDo', 'f', 'f', '', ''
where not EXISTS(SELECT id FROM task_schedule WHERE job_code='MqExceptionMsgReDo');
