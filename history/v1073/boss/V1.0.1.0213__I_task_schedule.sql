-- auto gen by kobe 2016-11-05 15:55:06
INSERT INTO "task_schedule" ("id", "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class") SELECT '798', 'payAccount-支付账户统计', NULL, NULL, 'so.wwb.gamebox.service.stat.PayAccountStatJob', 'execute', 't', '1', '0 05 5 * * ?', 't', '统计', '2016-11-05 12:04:18.283', NULL, 'stat-001', 't', 'f', '', '' WHERE  not EXISTS (SELECT id from task_schedule where id='798');

