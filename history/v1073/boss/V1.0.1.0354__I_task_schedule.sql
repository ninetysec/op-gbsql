-- auto gen by cherry 2017-06-22 15:48:21
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
SELECT '彩票监控未开奖记录', NULL, NULL, 'so.wwb.gamebox.service.company.LotteryWarningJob', 'execute', 't', '2', '10 0/5 * * * ?', 't', '彩票监控任务', now(), NULL, 'lottery_result_warning', 'f', 'f', NULL, NULL, 'A', 'scheduler4Lottery'
where not EXISTS (SELECT id FROM task_schedule where job_code='lottery_result_warning');