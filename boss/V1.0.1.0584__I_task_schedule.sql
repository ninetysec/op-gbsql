-- auto gen by marz 2018-07-15 17:45:19
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
SELECT '开奖结果校验任务', NULL, NULL, 'so.wwb.gamebox.service.company.lottery.job.LotteryResultOpenCodeValidJob', 'execute', 't', '1', '0 0/10 * * * ?', 't', '开奖结果校验任务', '2016-09-25 06:43:33.906', '2018-07-15 09:02:29.995', 'lotteryResultOpenCodeValidJob', 'f', 'f', '["bjpk10"]', 'java.lang.String[]', 'A', 'scheduler4LT'
where NOT EXISTS (select job_code FROM task_schedule where job_code='lotteryResultOpenCodeValidJob');
