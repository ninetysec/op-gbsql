-- auto gen by cherry 2017-09-20 20:55:12
INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc","scheduler")
SELECT '彩票杀率任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryKillRateJob', 'execute', 't', '1', '* * * * * ? 2020', 'f', '彩票杀率任务', '2016-09-25 06:43:33.906', NULL, 'lotteryKillRateJob', 'f', 'f', 'ffssc', 'java.lang.String', 'A','scheduler4Lottery'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryKillRateJob');

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
select   '站点任务-彩票汇总', NULL, NULL, 'so.wwb.gamebox.service.boss.job.SiteJobParentJob', 'execute', 't', '1', '50 * * * * ?', 't', '站点任务-分钟级定时触发', '2016-12-12 21:03:30', NULL, 'site-job-lotterysummary', 'f', 'f', '["site_job_103"]', 'java.lang.String[]', 'A', 'scheduler4Site'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'site-job-lotterysummary');

--修改时间:170909
INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc","scheduler")
SELECT '极速pk10采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '1', '0 0/1 * * * ?', 't', '极速pk10采集任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGather_jspk10', 'f', 'f', 'jspk10', 'java.lang.String', 'A','scheduler4Lottery'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGather_jspk10');



INSERT INTO "sys_resource" ("name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '杀率结果', 'lotteryResultKill/list.html', '彩票管理-杀率结果', '7', '', '5', 'boss', 'lottery:resultKill', '1', 'icon-xianshangzhifujilu', 'f', 't', 't'
WHERE not EXISTS(SELECT id FROM sys_resource where url = 'lotteryResultKill/list.html');
INSERT INTO "sys_resource" ("name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '汇总结果', 'lotteryOrderSummary/list.html', '彩票管理-汇总结果', '7', '', '10', 'boss', 'lottery:orderSummary', '1', 'icon-xianshangzhifujilu', 'f', 't', 't'
WHERE not EXISTS(SELECT id FROM sys_resource where url = 'lotteryOrderSummary/list.html');
INSERT INTO "sys_resource" ("name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '开奖记录', 'lotteryResultRecord/list.html', '彩票管理-开奖记录', '7', '', '11', 'boss', 'lottery:lotteryResultRecord', '1', 'icon-xianshangzhifujilu', 'f', 't', 't'
WHERE not EXISTS(SELECT id FROM sys_resource where url = 'lotteryResultRecord/list.html');


INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc","scheduler")
SELECT '彩票开奖结果采集任务', NULL, NULL, 'so.wwb.gamebox.service.boss.lottery.LotteryResultGatherJob', 'execute', 't', '1', '* * * * * ? 2020', 'f', '一次性任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGather', 'f', 'f', 'ALL', 'java.lang.String', 'A','scheduler4Lottery'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGather');

INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc","scheduler")
SELECT '彩票开奖结果主任务', NULL, NULL, 'so.wwb.gamebox.service.boss.job.LotteryResultGatherJobParentJob', 'execute', 't', '1', '0 0/1 * * * ?', 't', '彩票开奖结果主任务', '2016-09-25 06:43:33.906', NULL, 'lotteryResultGatherJobParentJob', 'f', 'f', '', 'java.lang.String', 'A','scheduler4Lottery'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryResultGatherJobParentJob');


INSERT INTO "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc","scheduler")
SELECT '彩票杀率主任务', NULL, NULL, 'so.wwb.gamebox.service.boss.job.LotteryKillRateJobParentJob', 'execute', 't', '1', '55 * * * * ?', 't', '彩票杀率主任务', '2016-09-25 06:43:33.906', NULL, 'lotteryKillRateJobParentJob', 'f', 'f', '', '', 'A','scheduler4Lottery'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'lotteryKillRateJobParentJob');


INSERT INTO task_schedule ( job_name, alias_name, job_group, job_class, job_method, is_local, status, cronexpression, is_sync, description, create_time, update_time, job_code, is_system, is_dynamic, job_method_arg, job_method_arg_class, belong_to_idc, scheduler)
select '站点任务-彩票汇总定时触发任务', null, null, 'so.wwb.gamebox.service.boss.job.LotterySummarySiteJobParentJob', 'execute', true, '1', '50 * * * * ?', false, '站点任务-彩票汇总定时触发任务', '2016-12-12 21:03:30.000000', null, 'site-job-parent-lotterysummary', false, false, null, null, 'A', 'scheduler4Site'
where not exists(select id from task_schedule t where t.job_code = 'site-job-parent-lotterysummary');

delete from task_schedule where job_code = 'site-job-lotterysummary';

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
select   '站点任务-彩票汇总', NULL, NULL, 'so.wwb.gamebox.service.boss.job.LotterySummarySiteJobParentJob', 'execute', 't', '1', '50 * * * * ?', 't', '站点任务-分钟级定时触发', '2016-12-12 21:03:30', NULL, 'site-job-parent-lotterysummary', 'f', 'f', '["site_job_103"]', 'java.lang.String[]', 'A', 'scheduler4Site'
WHERE not EXISTS(SELECT id FROM task_schedule where job_code = 'site-job-parent-lotterysummary');