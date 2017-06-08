-- auto gen by cherry 2017-06-08 20:22:19
INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc") SELECT
'重庆SSC彩票采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '2', '0 0/1 * * * ?', 't', '重庆SSC彩票采集任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGather_cqssc', 'f', 'f', 'cqssc', 'java.lang.String', 'A'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGather_cqssc');

INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc")
SELECT '香港六合彩彩票采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '2', '0 0/120 * * * ?', 't', '香港六合彩彩票采集任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGather_hklhc', 'f', 'f', 'hklhc', 'java.lang.String', 'A'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGather_hklhc');

INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc")
SELECT '北京pk10彩票采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '2', '0 0/1 * * * ?', 't', '北京pk10彩票采集任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGather_bjpk10', 'f', 'f', 'bjpk10', 'java.lang.String', 'A'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGather_bjpk10');

INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc")
SELECT '天津SSC彩票采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '2', '0 0/1 * * * ?', 't', '天津SSC彩票采集任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGather_tjssc', 'f', 'f', 'tjssc', 'java.lang.String', 'A'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGather_tjssc');

INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc")
SELECT '新疆SSC彩票采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '2', '0 0/1 * * * ?', 't', '新疆SSC彩票采集任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGather_xjssc', 'f', 'f', 'xjssc', 'java.lang.String', 'A'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGather_xjssc');

INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc")
SELECT '江苏快3彩票采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '2', '0 0/1 * * * ?', 't', '江苏快3彩票采集任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGather_jsk3', 'f', 'f', 'jsk3', 'java.lang.String', 'A'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGather_jsk3');

INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc")
SELECT '安徽快3彩票采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '2', '0 0/1 * * * ?', 't', '安徽快3彩票采集任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGather_ahk3', 'f', 'f', 'jsk3', 'java.lang.String', 'A'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGather_ahk3');

INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc")
SELECT '广西快3彩票采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '2', '0 0/1 * * * ?', 't', '广西快3彩票采集任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGather_gxk3', 'f', 'f', 'jsk3', 'java.lang.String', 'A'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGather_gxk3');

INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc")
SELECT '湖北快3彩票采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '2', '0 0/1 * * * ?', 't', '湖北快3彩票采集任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGather_hbk3', 'f', 'f', 'jsk3', 'java.lang.String', 'A'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGather_hbk3');