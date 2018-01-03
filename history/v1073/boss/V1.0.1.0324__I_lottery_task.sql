-- auto gen by admin 2017-05-02 14:45:55
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc")
SELECT '新疆SSC彩票采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '1', '0 0/1 * * * ?', 't', '新疆SSC彩票采集任务', '2016-09-25 06:43:33.906', NULL, 'lotterResultGather_xjssc', 'f', 'f', 'xjssc', 'java.lang.String','A'
where not EXISTS(SELECT id FROM task_schedule WHERE job_code='lotterResultGather_xjssc');


INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc")
SELECT '天津SSC彩票采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '1', '0 0/1 * * * ?', 't', '天津SSC彩票采集任务', '2016-09-25 06:43:33.906', NULL, 'lotterResultGather_tjssc', 'f', 'f', 'tjssc', 'java.lang.String','A'
where not EXISTS(SELECT id FROM task_schedule WHERE job_code='lotterResultGather_tjssc');


INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc")
SELECT '重庆SSC彩票采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '1', '0 0/1 * * * ?', 't', '重庆SSC彩票采集任务', '2016-09-25 06:43:33.906', NULL, 'lotterResultGather_cqssc', 'f', 'f', 'cqssc', 'java.lang.String','A'
where not EXISTS(SELECT id FROM task_schedule WHERE job_code='lotterResultGather_cqssc');


INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class","belong_to_idc")
SELECT '北京pk10彩票采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '1', '0 0/1 * * * ?', 't', '北京pk10彩票采集任务', '2016-09-25 06:43:33.906', NULL, 'lotterResultGather_bjpk10', 'f', 'f', 'bjpk10', 'java.lang.String','A'
where not EXISTS(SELECT id FROM task_schedule WHERE job_code='lotterResultGather_bjpk10');



INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class","belong_to_idc")
SELECT '香港六合彩彩票采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '1', '0 0/120 * * * ?', 't', '香港六合彩彩票采集任务', '2016-09-25 06:43:33.906', NULL, 'lotterResultGather_hklhc', 'f', 'f', 'hklhc', 'java.lang.String','A'
where not EXISTS(SELECT id FROM task_schedule WHERE job_code='lotterResultGather_hklhc');

