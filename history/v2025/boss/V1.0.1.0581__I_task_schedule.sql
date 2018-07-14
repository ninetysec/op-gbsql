-- auto gen by linsen 2018-07-02 11:48:22
-- 棋乐游 by zain

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")

SELECT  'apiId-43-QLY-新增下单记录', NULL, NULL, 'so.wwb.gamebox.service.company.PlayerGameOrderFetchJob', 'execute', 't', '1', '0 0/4 * * * ?', 't', 'api任务', '2018-04-24 02:13:48.132917', NULL, 'api-43-NORMAL', 'f', 'f', '43', 'java.lang.Integer', 'V', 'scheduler4Api'

WHERE not EXISTS(SELECT job_code FROM task_schedule where job_code='api-43-NORMAL' and job_method_arg='43');



INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")

SELECT  'apiId-43-QLY-对单记录', NULL, NULL, 'so.wwb.gamebox.service.company.PlayerGameOrderAdditionJob', 'execute', 't', '1', '0 0/4 * * * ?', 't', 'api任务', '2018-04-24 02:13:48.132917', NULL, 'api-43-CHECKUP_NORMAL', 'f', 'f', '43', 'java.lang.Integer', 'V', 'scheduler4Api'

WHERE not EXISTS(SELECT job_code FROM task_schedule where job_code='api-43-CHECKUP_NORMAL' and job_method_arg='43');



INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")

SELECT  'apiId-43-QLY-修改注单记录', NULL, NULL, 'so.wwb.gamebox.service.company.PlayerGameOrderModifierJob', 'execute', 't', '1', '0 0/4 * * * ?', 't', 'api任务', '2018-04-24 02:13:48.132917', NULL, 'api-43-MODIFY', 'f', 'f', '43', 'java.lang.Integer', 'V', 'scheduler4Api'

WHERE not EXISTS(SELECT job_code FROM task_schedule where job_code='api-43-MODIFY' and job_method_arg='43');



INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")

SELECT  'apiId-43-QLY-修改对单记录', NULL, NULL, 'so.wwb.gamebox.service.company.PlayerGameOrderCheckJob', 'execute', 't', '1', '0 0/4 * * * ?', 't', 'api任务', '2018-04-24 02:13:48.132917', NULL, 'api-43-mc', 'f', 'f', '43', 'java.lang.Integer', 'V', 'scheduler4Api'

WHERE not EXISTS(SELECT job_code FROM task_schedule where job_code='api-43-mc' and job_method_arg='43');



INSERT INTO "game_api_provider" ("id", "abbr_name", "full_name", "api_url", "remarks", "jar_url", "api_class", "jar_version", "ext_json", "default_timezone", "support_agent", "trial")

SELECT '43', 'QLY', '棋乐游', 'http://3rd.game.api.com/qly-api/agent/{0}?agent={1}&timestamp={2}&sign={3}&params={4}', '测试环境http://tapi.761city.com:10018/agent', 'file:/data/impl-jars/api/api-qly.jar', 'so.wwb.gamebox.service.gameapi.impl.QlyGameApi', '201804240104546',

'{ "agent": 1064,"appKey":"41792803cfd52cfb037d61433bee8836","search_advance_amount_second":10,"pagenum":1000,"conversion_ratio":10000}', '-8', 'f', 'f'  WHERE

43 NOT IN (SELECT id FROM game_api_provider WHERE id=43);





-- 注册

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")

SELECT '4301', 'HTTP', 'login', 'register', 'GET', '棋乐游-注册', 'org.soul.model.gameapi.param.RegisterParam', 'org.soul.model.gameapi.result.RegisterResult', 'FORM', 'FORM', '43', ''

WHERE 4301 NOT IN(SELECT id FROM game_api_interface WHERE id=4301);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")

 SELECT '43011', 'acc', 'user.account', 't', NULL, NULL, '', '', '4301', '', '棋乐游-用户名', '', ''

WHERE 43011 NOT IN(SELECT id FROM game_api_interface_request WHERE id=43011);



-- 登录

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")

SELECT '4302', 'HTTP', 'login', 'login', 'GET', '棋乐游-登录', 'org.soul.model.gameapi.param.LoginParam', 'org.soul.model.gameapi.result.LoginResult', 'FORM', 'FORM', '43', ''

WHERE 4302 NOT IN(SELECT id FROM game_api_interface WHERE id=4302);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")

 SELECT '43021', 'acc', 'user.account', 't', NULL, NULL, '', '', '4302', '', '棋乐游-用户名', '', ''

WHERE 43021 NOT IN(SELECT id FROM game_api_interface_request WHERE id=43021);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")

 SELECT '43022', 'game', 'gameId', 'f', NULL, NULL, '', '', '4302', '', '棋乐游-游戏', '', ''

WHERE 43022 NOT IN(SELECT id FROM game_api_interface_request WHERE id=43022);



-- 踢出

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")

SELECT '4303', 'HTTP', 'kickout', 'kickOut', 'GET', '棋乐游-踢出玩家', 'org.soul.model.gameapi.param.KickOutParam', 'org.soul.model.gameapi.result.KickOutResult', 'FORM', 'FORM', '43', ''

WHERE 4303 NOT IN(SELECT id FROM game_api_interface WHERE id=4303);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")

 SELECT '43031', 'acc', 'user.account', 't', NULL, NULL, '', '', '4303', '', '棋乐游-用户名', '', ''

WHERE 43031 NOT IN(SELECT id FROM game_api_interface_request WHERE id=43031);



-- 游戏记录

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")

SELECT '4304', 'HTTP', 'loadrecords', 'fetchRecord', 'GET', '棋乐游-查询游戏记录', 'org.soul.model.gameapi.param.FetchRecordParam', 'org.soul.model.gameapi.result.FetchRecordResult', 'FORM', 'FORM', '43', ''

WHERE 4304 NOT IN(SELECT id FROM game_api_interface WHERE id=4304);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")

 SELECT '43041', 'stime', 'startTime', 't', NULL, NULL, '', '', '4304', '', '棋乐游-询的起始时间', '', ''

WHERE 43041 NOT IN(SELECT id FROM game_api_interface_request WHERE id=43041);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")

 SELECT '43042', 'etime', 'endTime', 't', NULL, NULL, '', '', '4304', '', '棋乐游-查询的结束时间', '', ''

WHERE 43042 NOT IN(SELECT id FROM game_api_interface_request WHERE id=43042);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")

 SELECT '43043', 'pagenum', 'pagenum', 't', NULL, NULL, '', '', '4304', '', '棋乐游-页面容量', '', ''

WHERE 43043 NOT IN(SELECT id FROM game_api_interface_request WHERE id=43043);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")

 SELECT '43044', 'page', 'page', 't', NULL, NULL, '', '', '4304', '', '棋乐游-页码', '', ''

WHERE 43044 NOT IN(SELECT id FROM game_api_interface_request WHERE id=43044);



-- 获取修改的注单

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")

SELECT '4305', 'HTTP', 'loadrecords', 'fetchModifiedRecord', 'GET', '棋乐游-查询游戏记录', 'org.soul.model.gameapi.param.FetchModifiedRecordParam', 'org.soul.model.gameapi.result.FetchModifiedRecordResult', 'FORM', 'FORM', '43', ''

WHERE 4305 NOT IN(SELECT id FROM game_api_interface WHERE id=4305);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")

 SELECT '43051', 'stime', 'startTime', 't', NULL, NULL, '', '', '4305', '', '棋乐游-询的起始时间', '', ''

WHERE 43051 NOT IN(SELECT id FROM game_api_interface_request WHERE id=43051);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")

 SELECT '43052', 'etime', 'endTime', 't', NULL, NULL, '', '', '4305', '', '棋乐游-查询的结束时间', '', ''

WHERE 43052 NOT IN(SELECT id FROM game_api_interface_request WHERE id=43052);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")

 SELECT '43053', 'pagenum', 'pagenum', 't', NULL, NULL, '', '', '4305', '', '棋乐游-页面容量', '', ''

WHERE 43053 NOT IN(SELECT id FROM game_api_interface_request WHERE id=43053);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")

 SELECT '43054', 'page', 'page', 't', NULL, NULL, '', '', '4305', '', '棋乐游-页码', '', ''

WHERE 43054 NOT IN(SELECT id FROM game_api_interface_request WHERE id=43054);



-- 查询余额

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")

SELECT '4306', 'HTTP', 'getbalance', 'fetchBalance', 'GET', '棋乐游-查询余额', 'org.soul.model.gameapi.param.FetchBalanceParam', 'org.soul.model.gameapi.result.FetchBalanceResult', 'FORM', 'FORM', '43', ''

WHERE 4306 NOT IN(SELECT id FROM game_api_interface WHERE id=4306);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")

 SELECT '43061', 'acc', 'user.account', 't', NULL, NULL, '', '', '4306', '', '棋乐游-用户名', '', ''

WHERE 43061 NOT IN(SELECT id FROM game_api_interface_request WHERE id=43061);





-- 提现

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")

SELECT '4307', 'HTTP', 'paydown', 'withdraw', 'GET', '棋乐游-提现', 'org.soul.model.gameapi.param.WithdrawParam', 'org.soul.model.gameapi.result.WithdrawResult', 'FORM', 'FORM', '43', ''

WHERE 4307 NOT IN(SELECT id FROM game_api_interface WHERE id=4307);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")

 SELECT '43071', 'acc', 'user.account', 't', NULL, NULL, '', '', '4307', '', '棋乐游-用户名', '', ''

WHERE 43071 NOT IN(SELECT id FROM game_api_interface_request WHERE id=43071);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")

 SELECT '43072', 'money', 'amount', 't', NULL, NULL, '', '', '4307', '', '棋乐游-交易金额', '', ''

WHERE 43072 NOT IN(SELECT id FROM game_api_interface_request WHERE id=43072);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")

 SELECT '43073', 'orderid', 'transId', 't', NULL, NULL, '', '', '4307', '', '棋乐游-订单号', '', ''

WHERE 43073 NOT IN(SELECT id FROM game_api_interface_request WHERE id=43073);



-- 充值

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")

SELECT '4308', 'HTTP', 'payup', 'deposit', 'GET', '棋乐游-充值', 'org.soul.model.gameapi.param.DepositParam', 'org.soul.model.gameapi.result.DepositResult', 'FORM', 'FORM', '43', ''

WHERE 4308 NOT IN(SELECT id FROM game_api_interface WHERE id=4308);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")

 SELECT '43081', 'acc', 'user.account', 't', NULL, NULL, '', '', '4308', '', '棋乐游-用户名', '', ''

WHERE 43081 NOT IN(SELECT id FROM game_api_interface_request WHERE id=43081);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")

 SELECT '43082', 'money', 'amount', 't', NULL, NULL, '', '', '4308', '', '棋乐游-交易金额', '', ''

WHERE 43082 NOT IN(SELECT id FROM game_api_interface_request WHERE id=43082);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")

 SELECT '43083', 'orderid', 'transId', 't', NULL, NULL, '', '', '4308', '', '棋乐游-订单号', '', ''

WHERE 43083 NOT IN(SELECT id FROM game_api_interface_request WHERE id=43083);



-- CHECK

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")

SELECT '4309', 'HTTP', 'getorderstatus', 'checkTransfer', 'GET', '棋乐游-查询订单状态', 'org.soul.model.gameapi.param.CheckTransferParam', 'org.soul.model.gameapi.result.CheckTransferResult', 'FORM', 'FORM', '43', ''

WHERE 4309 NOT IN(SELECT id FROM game_api_interface WHERE id=4309);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")

 SELECT '43091', 'acc', 'user.account', 't', NULL, NULL, '', '', '4309', '', '棋乐游-玩家账号', '', ''

WHERE 43091 NOT IN(SELECT id FROM game_api_interface_request WHERE id=43091);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")

 SELECT '43092', 'orderid', 'transId', 't', NULL, NULL, '', '', '4309', '', '棋乐游-订单号', '', ''

WHERE 43092 NOT IN(SELECT id FROM game_api_interface_request WHERE id=43092);