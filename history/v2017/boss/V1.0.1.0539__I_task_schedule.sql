-- auto gen by linsen 2018-04-01 10:27:32
--重建恢复买分额度任务 by younger
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
SELECT  '恢复东区站点买分默认额度', NULL, NULL, 'so.wwb.gamebox.service.company.CreditResetQuotaJob', 'execute', 't', '2', '1 0 12/1 L * ?', 't', '全站任务', '2018-03-29 11:07:04.153', null, 'credit-reset-east', 'f', 'f', '', '', 'A', 'scheduler4Default'
where NOT EXISTS (select job_class FROM task_schedule where job_code='credit-reset-east');


INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
SELECT  '恢复西区站点买分默认额度', NULL, NULL, 'so.wwb.gamebox.service.company.CreditResetQuotaJob', 'execute', 't', '2', '1 0 0-12/1 1 * ? ', 't', '全站任务', '2018-03-29 11:07:04.153', null, 'credit-reset-west', 'f', 'f', '', '', 'A', 'scheduler4Default'
where NOT EXISTS (select job_class FROM task_schedule where job_code='credit-reset-west');

