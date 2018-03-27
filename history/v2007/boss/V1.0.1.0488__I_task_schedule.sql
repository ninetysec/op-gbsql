-- auto gen by george 2018-01-10 09:13:27

--添加开启禁用转账功能任务
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
SELECT '开启禁用转账功能任务', NULL, NULL, 'so.wwb.gamebox.service.company.OpenDisableTransferJob', 'execute', 't', '1', '0 */1 * * * ?', 't', '全站任务', '2018-01-09 12:07:04.153', NULL, 'disable-transfer', 'f', 'f', '', '', 'A', 'scheduler4Default'
where not exists (select id from task_schedule where job_code='disable-transfer');
