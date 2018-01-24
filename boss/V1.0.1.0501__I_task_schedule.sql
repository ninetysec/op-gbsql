-- auto gen by george 2018-01-24 18:57:38

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
SELECT '清空存款总数和总额', NULL, NULL, 'so.wwb.gamebox.service.company.ClearCreditAccountColumnJob', 'execute', 't', '2', '0 0 1 ? * 1', 't', '全站任务', '2018-01-24 08:13:48.132917', '2018-01-24 02:30:37.354', 'clear-credit-account', 'f', 'f', '', '', 'A', 'scheduler4Default'
WHERE 'clear-credit-account'  NOT in (SELECT job_code FROM task_schedule WHERE job_code='clear-credit-account');

