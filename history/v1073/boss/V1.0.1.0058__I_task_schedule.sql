-- auto gen by wayne 2016-05-23 11:20:29

INSERT INTO  "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
  SELECT 'apiId-4-im-采集任务', NULL, NULL, 'so.wwb.gamebox.service.company.ImGatherRecordJob', 'execute', 't', '1', '0 0/5 * * * ?', 't', 'api采集任务', '2015-11-02 16:51:16', NULL, 'api-4-IM-Gather', 't', 'f', '0', 'java.lang.Integer'
  WHERE NOT EXISTS(SELECT job_code FROM task_schedule WHERE job_code='api-4-IM-Gather');