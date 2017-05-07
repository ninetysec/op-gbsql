-- auto gen by admin 2016-04-13 21:24:13
-- auto gen by admin 2016-04-13 11:06:51
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT '同步api余额', NULL, NULL, 'so.wwb.gamebox.iservice.master.player.IPlayerApiService', 'fetchApiBalance', 'f', '1', '* * * * * ? 2020', 't', '一次性任务', '2016-04-12 17:33:34', NULL, 'once-004', 't', 'f', NULL, NULL
where  'once-004' not in(SELECT job_code from task_schedule where job_code='once-004');