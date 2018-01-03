-- auto gen by fei 2017-11-27 17:40:23
INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
SELECT  '彩票盈利报表', NULL, NULL, 'so.wwb.gamebox.service.company.lottery.job.LotteryReportJob', 'execute', 't', '1', '0 0 17 * * ?', 't', '彩票盈利报表统计任务', '2017-05-24 02:13:48.132917', NULL, 'lotteryReportJob', 'f', 'f', '', '', 'A', 'scheduler4LT'
WHERE NOT EXISTS(SELECT id  FROM  task_schedule where  job_code='lotteryReportJob' AND scheduler = 'scheduler4LT');


INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc","scheduler")
SELECT '彩票开奖结果采集任务', NULL, NULL, 'so.wwb.gamebox.service.company.lottery.job.LotteryResultSubJob', 'execute', 't', '1', '* * * * * ? 2020', 'f', '一次性任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultSubJob', 'f', 'f', 'ALL', 'java.lang.String', 'A','scheduler4LT'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultSubJob' AND scheduler = 'scheduler4LT');


INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc","scheduler")
SELECT '彩票开奖结果主任务', NULL, NULL, 'so.wwb.gamebox.service.company.lottery.job.LotteryResultMainJob', 'execute', 't', '1', '0 0/1 * * * ?', 't', '彩票开奖结果主任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultMainJob', 'f', 'f', '', 'java.lang.String', 'A','scheduler4LT'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultMainJob' AND scheduler = 'scheduler4LT');


INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class","belong_to_idc","scheduler")
SELECT '彩票开奖结果初始化任务', NULL, NULL, 'so.wwb.gamebox.service.company.lottery.job.LotteryResultProduceJob', 'execute', 't', '1', '0 1/1200 * * * ?', 't', '彩票开奖结果初始化任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultProduceJob', 'f', 'f', '', '','A','scheduler4LT'
where not EXISTS(SELECT id FROM task_schedule WHERE job_code='lotteryResultProduceJob' AND scheduler = 'scheduler4LT');


INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
SELECT '彩票派彩任务', NULL, NULL, 'so.wwb.gamebox.service.company.lottery.job.LotteryResultPayoutJob', 'execute', 't', '1', '0 0/3 * * * ?', 't', '彩票派彩任务', '2017-08-11 06:43:33.906', NULL, 'lotteryResultPayoutJob', 'f', 'f', '5', 'java.lang.Integer', 'B', 'scheduler4LT'
WHERE NOT EXISTS (SELECT job_code from task_schedule where job_code='lotteryResultPayoutJob' AND scheduler = 'scheduler4LT');


INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc","scheduler")
SELECT '彩票600万封盘时间验证任务', NULL, NULL, 'so.wwb.gamebox.service.company.lottery.job.LotteryResultCheckJob', 'execute', 't', '1', '0 0/1 * * * ?', 't', '彩票600万封盘时间验证任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultCheckJob', 'f', 'f', 'ALL', 'java.lang.String', 'A','scheduler4LT'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultCheckJob' AND scheduler = 'scheduler4LT');

