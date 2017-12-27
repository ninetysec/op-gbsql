-- auto gen by george 2017-12-27 14:56:49
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
SELECT '批量结算返水', NULL, NULL, 'so.wwb.gamebox.service.master.RakebackSettlementJob',
'execute', 't', '1', '* * * * * ? 2020', 't', '一次性任务', now(), NULL, 'once-005', 't', 'f',
NULL, NULL, 'A', 'scheduler4Once'
WHERE NOt EXISTS (SELECT id FROM task_schedule WHERE job_code='once-005');