-- auto gen by cherry 2017-09-04 19:03:58
INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc","scheduler")
SELECT '幸运飞艇彩票采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '1', '0 4/5 * * * ?', 't', '幸运飞艇彩票采集任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGather_xyft', 'f', 'f', 'xyft', 'java.lang.String', 'A','scheduler4Lottery'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGather_xyft');


INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc","scheduler")
SELECT '重庆幸运农场彩票采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '1', '0 3/5 * * * ?', 't', '重庆幸运农场彩票采集任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGather_cqxync', 'f', 'f', 'cqxync', 'java.lang.String', 'A','scheduler4Lottery'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGather_cqxync');


INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc","scheduler")
SELECT '广东快乐十分彩票采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '1', '0 0/5 * * * ?', 't', '广东快乐十分彩票采集任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGather_gdkl10', 'f', 'f', 'gdkl10', 'java.lang.String', 'A','scheduler4Lottery'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGather_gdkl10');


INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc","scheduler")
SELECT '北京快乐8彩票采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '1', '0 0/5 * * * ?', 't', '北京快乐8彩票采集任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGather_bjkl8', 'f', 'f', 'bjkl8', 'java.lang.String', 'A','scheduler4Lottery'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGather_bjkl8');


INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc","scheduler")
SELECT '福彩3D彩票采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '1', '0 0/30 * * * ?', 't', '福彩3D彩票采集任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGather_fc3d', 'f', 'f', 'fc3d', 'java.lang.String', 'A','scheduler4Lottery'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGather_fc3d');


INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc","scheduler")
SELECT '体彩排列3彩票采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '1', '0 0/30 * * * ?', 't', '体彩排列3彩票采集任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGather_tcpl3', 'f', 'f', 'tcpl3', 'java.lang.String', 'A','scheduler4Lottery'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGather_tcpl3');


INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc","scheduler")
SELECT '彩票600万封盘时间验证任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultValidJob', 'execute', 't', '1', '0 0/1 * * * ?', 't', '彩票600万封盘时间验证任务', '2016-09-25 06:43:33.906', NULL, 'LotteryResultValidJob_lbw', 'f', 'f', 'ALL', 'java.lang.String', 'A','scheduler4Lottery'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'LotteryResultValidJob_lbw');


INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc","scheduler")
SELECT '分分时时彩采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '1', '0 0/1 * * * ?', 't', '分分时时彩采集任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGather_ffssc', 'f', 'f', 'ffssc', 'java.lang.String', 'A','scheduler4Lottery'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGather_ffssc');

INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc","scheduler")
SELECT '二分时时彩采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '1', '0 0/2 * * * ?', 't', '二分时时彩采集任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGather_efssc', 'f', 'f', 'efssc', 'java.lang.String', 'A','scheduler4Lottery'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGather_efssc');


INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc","scheduler")
SELECT '三分时时彩采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '1', '0 0/3 * * * ?', 't', '三分时时彩采集任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGather_sfssc', 'f', 'f', 'sfssc', 'java.lang.String', 'A','scheduler4Lottery'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGather_sfssc');


INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc","scheduler")
SELECT '五分时时彩采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '1', '0 0/5 * * * ?', 't', '五分时时彩采集任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGather_wfssc', 'f', 'f', 'wfssc', 'java.lang.String', 'A','scheduler4Lottery'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGather_wfssc');


INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc","scheduler")
SELECT '彩票杀率任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryKillRateJob', 'execute', 't', '1', '0 0/1 * * * ?', 't', '彩票杀率任务', '2016-09-25 06:43:33.906', NULL, 'lotteryKillRateJob_ffssc', 'f', 'f', 'ffssc', 'java.lang.String', 'A','scheduler4Lottery'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryKillRateJob_ffssc');
