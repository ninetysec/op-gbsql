-- auto gen by longer 2017-07-04 16:28:48

--任务调度: 初全179两个任务
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class","belong_to_idc","scheduler")
VALUES ('siteId-179-线上支付超时订单处理任务', NULL, NULL, 'so.wwb.gamebox.service.master.OnlineRechargeJob', 'execute', 't', '1', '0 0/1 * * * ?', 't', '站点任务', now(), NULL, 'site-179-007', 'f', 'f', '179', 'java.lang.Integer','A','scheduler4Default');
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class","belong_to_idc","scheduler")
VALUES ('siteId-179-转账超时订单处理任务', NULL, NULL, 'so.wwb.gamebox.service.master.TransferJob', 'execute', 't', '1', '31 0/1 * * * ?', 't', '站点任务', now(), NULL, 'site-179-012', 'f', 'f', '179', 'java.lang.Integer','A','scheduler4Default');

--任务调度: 初全180两个任务
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class","belong_to_idc","scheduler")
VALUES ('siteId-180-线上支付超时订单处理任务', NULL, NULL, 'so.wwb.gamebox.service.master.OnlineRechargeJob', 'execute', 't', '1', '0 0/1 * * * ?', 't', '站点任务', now(), NULL, 'site-180-007', 'f', 'f', '180', 'java.lang.Integer','A','scheduler4Default');
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class","belong_to_idc","scheduler")
VALUES ('siteId-180-转账超时订单处理任务', NULL, NULL, 'so.wwb.gamebox.service.master.TransferJob', 'execute', 't', '1', '31 0/1 * * * ?', 't', '站点任务', now(), NULL, 'site-180-012', 'f', 'f', '180', 'java.lang.Integer','A','scheduler4Default');

--任务调度: 初全181两个任务
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class","belong_to_idc","scheduler")
VALUES ('siteId-181-线上支付超时订单处理任务', NULL, NULL, 'so.wwb.gamebox.service.master.OnlineRechargeJob', 'execute', 't', '1', '0 0/1 * * * ?', 't', '站点任务', now(), NULL, 'site-181-007', 'f', 'f', '181', 'java.lang.Integer','A','scheduler4Default');
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class","belong_to_idc","scheduler")
VALUES ('siteId-181-转账超时订单处理任务', NULL, NULL, 'so.wwb.gamebox.service.master.TransferJob', 'execute', 't', '1', '31 0/1 * * * ?', 't', '站点任务', now(), NULL, 'site-181-012', 'f', 'f', '181', 'java.lang.Integer','A','scheduler4Default');
