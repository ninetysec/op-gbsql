-- auto gen by cherry 2016-07-26 21:53:17
INSERT INTO "pay_api_provider" ("id", "channel_code", "remarks", "jar_url", "api_class", "jar_version", "ext_json")
SELECT '19', 'allscore_wx', NULL, 'file:/data/impl-jars/pay-allscore.jar', 'org.soul.pay.impl.AllscorePayWXApi', '20160720',
'{"pro":{"payUrl":"https://paymenta.allscore.com/olgateway/serviceDirect.htm","queryOrderUrl":"https://3rd.pay.api.com/allscore-pay/wxpay/olgateway/orderQuery.htm"},"test":{"payUrl":"http://211.157.145.8:8090/olgateway/serviceDirect.htm","queryOrderUrl":"http://211.157.145.8:8090/olgateway/orderQuery.htm"}}'
WHERE  not EXISTS (SELECT channel_code from pay_api_provider where channel_code='allscore_wx');

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT 'apiId-12-ss-下单记录', NULL, NULL, 'so.wwb.gamebox.service.company.PlayerGameOrderFetchJob', 'execute', 't', '2', '0 0/4 * * * ?', 't', 'api任务', now(), NULL, 'api-12-I', 'f', 'f', '12', 'java.lang.Integer'
where not EXISTS (SELECT id from task_schedule where job_code='api-12-I');

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT 'apiId-12-ss-修改下单记录', NULL, NULL, 'so.wwb.gamebox.service.company.PlayerGameOrderModifierJob', 'execute', 't', '2', '0 0/10 * * * ?', 't', 'api任务', '2016-01-15 10:11:59.123', NULL, 'api-12-M', 'f', 'f', '12', 'java.lang.Integer'
WHERE not EXISTS(SELECT id from task_schedule where job_code='api-12-M');
