-- auto gen by marz 2018-05-31 13:53:22
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
SELECT '极速pk10开奖主任务', NULL, NULL, 'so.wwb.gamebox.service.company.lottery.job.LotteryResultUserDefinedJob', 'execute', 't', '1', '0 0/1 * * * ?', 't', '极速pk10开奖主任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultUserDefinedJob_jspk10', 'f', 'f', '["jspk10"]', 'java.lang.String[]', 'A', 'scheduler4LT'
where NOT EXISTS (select job_code FROM task_schedule where job_code='lotteryResultUserDefinedJob_jspk10');

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
SELECT '分分时时彩开奖主任务', NULL, NULL, 'so.wwb.gamebox.service.company.lottery.job.LotteryResultUserDefinedJob', 'execute', 't', '1', '0 0/1 * * * ?', 't', '分分时时彩开奖主任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultUserDefinedJob_ffssc', 'f', 'f', '["ffssc"]', 'java.lang.String[]', 'A', 'scheduler4LT'
where NOT EXISTS (select job_code FROM task_schedule where job_code='lotteryResultUserDefinedJob_ffssc');

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
SELECT '官方时时彩开奖主任务', NULL, NULL, 'so.wwb.gamebox.service.company.lottery.job.LotteryResultUserDefinedJob', 'execute', 't', '1', '0 0/1 * * * ?', 't', '官方时时彩开奖主任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultUserDefinedJob_ssc', 'f', 'f', '["cqssc","xjssc","tjssc"]', 'java.lang.String[]', 'A', 'scheduler4LT'
where NOT EXISTS (select job_code FROM task_schedule where job_code='lotteryResultUserDefinedJob_ssc');

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
SELECT '官方快3开奖主任务', NULL, NULL, 'so.wwb.gamebox.service.company.lottery.job.LotteryResultUserDefinedJob', 'execute', 't', '1', '0 0/1 * * * ?', 't', '官方快3开奖主任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultUserDefinedJob_k3', 'f', 'f', '["jsk3","ahk3","hbk3","gxk3"]', 'java.lang.String[]', 'A', 'scheduler4LT'
where NOT EXISTS (select job_code FROM task_schedule where job_code='lotteryResultUserDefinedJob_k3');

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
SELECT '官方PK10开奖主任务', NULL, NULL, 'so.wwb.gamebox.service.company.lottery.job.LotteryResultUserDefinedJob', 'execute', 't', '1', '0 0/1 * * * ?', 't', '官方PK10开奖主任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultUserDefinedJob_pk10', 'f', 'f', '["bjpk10","xyft"]', 'java.lang.String[]', 'A', 'scheduler4LT'
where NOT EXISTS (select job_code FROM task_schedule where job_code='lotteryResultUserDefinedJob_pk10');

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
SELECT '官方十分彩开奖主任务', NULL, NULL, 'so.wwb.gamebox.service.company.lottery.job.LotteryResultUserDefinedJob', 'execute', 't', '1', '0 0/1 * * * ?', 't', '官方十分彩开奖主任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultUserDefinedJob_sfc', 'f', 'f', '["cqxync","gdkl10"]', 'java.lang.String[]', 'A', 'scheduler4LT'
where NOT EXISTS (select job_code FROM task_schedule where job_code='lotteryResultUserDefinedJob_sfc');

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
SELECT '官方低频彩开奖主任务', NULL, NULL, 'so.wwb.gamebox.service.company.lottery.job.LotteryResultUserDefinedJob', 'execute', 't', '1', '0 15/1 12,13 * * ?', 't', '官方低频彩开奖主任务,每天晚上8点15-59与9点15-59分每隔1分钟触发一次', '2016-09-25 06:43:33.906', NULL, 'lotteryResultUserDefinedJob_low', 'f', 'f', '["fc3d","tcpl3","hklhc"]', 'java.lang.String[]', 'A', 'scheduler4LT'
where NOT EXISTS (select job_code FROM task_schedule where job_code='lotteryResultUserDefinedJob_low');

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
SELECT '官方快乐彩开奖主任务', NULL, NULL, 'so.wwb.gamebox.service.company.lottery.job.LotteryResultUserDefinedJob', 'execute', 't', '1', '0 0/1 * * * ?', 't', '官方快乐彩开奖主任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultUserDefinedJob_keno', 'f', 'f', '["bjkl8","xy28"]', 'java.lang.String[]', 'A', 'scheduler4LT'
where NOT EXISTS (select job_code FROM task_schedule where job_code='lotteryResultUserDefinedJob_keno');
