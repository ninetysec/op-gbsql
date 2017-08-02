-- auto gen by cherry 2017-08-01 14:58:35
alter table live_order_result ALTER column player_point TYPE varchar(200);
alter table live_order_result ALTER column gameinformation TYPE varchar(300);

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
SELECT  'apiId-20-BSG-新增下单记录', NULL, NULL, 'so.wwb.gamebox.service.company.PlayerGameOrderFetchJob', 'execute', 't', '1', '0 0/4 * * * ?', 't', 'api任务', '2017-05-24 02:13:48.132917', NULL, 'api-20-I', 'f', 'f', '20', 'java.lang.Integer', 'A', 'scheduler4Api'
WHERE not EXISTS(SELECT job_code FROM task_schedule where job_code='api-20-I');