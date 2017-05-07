-- auto gen by admin 2016-05-04 20:27:41
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT 'apiId-10-bbin-下单记录', NULL, NULL, 'so.wwb.gamebox.service.company.PlayerGameOrderFetchJob', 'execute', 't', '1', '0 0/5 * * * ?', 't', 'api任务', '2016-01-15 10:09:31.412', NULL, 'api-10-I', 't', 'f', '10', 'java.lang.Integer'
WHERE 'api-10-I'  NOT in (SELECT job_code FROM task_schedule WHERE job_code='api-10-I');


INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT 'apiId-10-bbin-修改下单记录', NULL, NULL, 'so.wwb.gamebox.service.company.PlayerGameOrderModifierJob', 'execute', 't', '1', '0 0/10 * * * ?', 't', 'api任务', '2016-01-15 10:11:59.123', NULL, 'api-10-M', 't', 'f', '10', 'java.lang.Integer'
WHERE 'api-10-M'  NOT in (SELECT job_code FROM task_schedule WHERE job_code='api-10-M');

UPDATE task_schedule SET cronexpression='0 0/5 * * * ?' WHERE job_code in ('api-1-I','api-2-I','api-3-I','api-4-I','api-5-I','api-6-I','api-7-I','api-8-I','api-9-I','api-10-I');

UPDATE task_schedule SET cronexpression='0 0/10 * * * ?' WHERE job_code in ('api-1-M','api-2-M','api-3-M','api-4-M','api-5-M','api-6-M','api-7-M','api-8-M','api-9-M','api-10-M');

UPDATE task_schedule SET cronexpression='0 0/5 * * * ?' WHERE job_name LIKE '%线上支付超时订单处理任务' OR job_name LIKE '%转账超时订单处理任务';

UPDATE task_schedule SET job_class='so.wwb.gamebox.service.stat.OperationProcedureJob' WHERE job_code='all-004';


