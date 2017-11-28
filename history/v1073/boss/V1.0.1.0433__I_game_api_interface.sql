-- auto gen by george 2017-11-01 09:14:00
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
SELECT  'apiId-21-新皇冠体育-新增下单记录', NULL, NULL, 'so.wwb.gamebox.service.company.PlayerGameOrderFetchJob', 'execute', 't', '1', '0 0/4 * * * ?', 't', 'api任务', '2017-05-24 02:13:48.132917', NULL, 'api-21-I', 'f', 'f', '21', 'java.lang.Integer', 'A', 'scheduler4Api'
WHERE not EXISTS(SELECT job_code FROM task_schedule where job_code='api-21-I' and job_method_arg='21');

INSERT INTO "game_api_provider" ("id", "abbr_name", "full_name", "api_url", "remarks", "jar_url", "api_class", "jar_version", "ext_json", "default_timezone", "support_agent", "trial")
SELECT '21', 'DWT', '', 'shanghu01api.sports-hg.com/api/entrance/VUZ/process', '', '/gamebox-api/api-impl/impl-jars/api/api-sport.jar', 'so.wwb.gamebox.service.gameapi.impl.SportGameApi', '20170930010918', '{"search-minute":"10","isFetchRecord":true,"merchant":"VUZ","key":"VGYEZOUJIKJUH3T","mode":"1","pageSize":"1000","pageNum":"1"}', '-4', 'f', 'f'
 WHERE 21 NOT IN(SELECT id FROM game_api_provider WHERE id=21);


 INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
  SELECT '2101', 'HTTP', 'register', 'register', 'POST', 'SPORT-创建账号', 'org.soul.model.gameapi.param.RegisterParam', 'org.soul.model.gameapi.result.RegisterResult', 'JSON', 'JSON', '21', NULL
  WHERE 2101 NOT IN(SELECT id FROM game_api_interface WHERE id=2101);

   INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
  SELECT '2102', 'HTTP', 'login', 'login', 'POST', 'SPORT-登录到游戏平台', 'org.soul.model.gameapi.param.LoginParam', 'org.soul.model.gameapi.result.LoginResult', 'JSON', 'JSON', '21', NULL
  WHERE 2102 NOT IN(SELECT id FROM game_api_interface WHERE id=2102);

   INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
  SELECT '2103', 'HTTP', 'balance', 'fetchBalance', 'POST', 'SPORT-获取游戏平台即时余额', 'org.soul.model.gameapi.param.FetchBalanceParam', 'org.soul.model.gameapi.result.FetchBalanceResult', 'JSON', 'JSON', '21', NULL
  WHERE 2103 NOT IN(SELECT id FROM game_api_interface WHERE id=2103);

   INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
  SELECT '2104', 'HTTP', 'withdraw', 'withdraw', 'POST', 'SPORT-从游戏平台取款', 'org.soul.model.gameapi.param.WithdrawParam', 'org.soul.model.gameapi.result.WithdrawResult', 'JSON', 'JSON', '21', NULL
  WHERE 2104 NOT IN(SELECT id FROM game_api_interface WHERE id=2104);

   INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
  SELECT '2105', 'HTTP', 'deposit', 'deposit', 'POST', 'SPORT-从游戏平台存款', 'org.soul.model.gameapi.param.WithdrawParam', 'org.soul.model.gameapi.result.DepositResult', 'JSON', 'JSON', '21', NULL
  WHERE 2105 NOT IN(SELECT id FROM game_api_interface WHERE id=2105);

   INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
  SELECT '2106', 'HTTP', 'check', 'checkTransfer', 'POST', 'SPORT-确认转账', 'org.soul.model.gameapi.param.WithdrawParam', 'org.soul.model.gameapi.result.CheckTransferResult', 'JSON', 'JSON', '21', NULL
  WHERE 2106 NOT IN(SELECT id FROM game_api_interface WHERE id=2106);

  INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
  SELECT '2107', 'HTTP', 'record', 'fetchRecord', 'POST', 'SPORT-获取注单', 'org.soul.model.gameapi.param.FetchRecordParam', 'org.soul.model.gameapi.result.FetchRecordResult', 'JSON', 'JSON', '21', NULL
  WHERE 2107 NOT IN(SELECT id FROM game_api_interface WHERE id=2107);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21011', 'userName', 'user.account', 't', NULL, NULL, NULL, '', '2101', '', 'SPORT-用户名', '', ''
 WHERE 21011 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21011);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21012', 'password', 'user.password', 't', NULL, NULL, NULL, '', '2101', '', 'SPORT-密码', '', ''
 WHERE 21012 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21012);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21013', 'nickName', 'user.account', 't', NULL, NULL, NULL, '', '2101', '', 'SPORT-昵称', '', ''
 WHERE 21013 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21013);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21014', 'currency', 'user.currency', 't', NULL, NULL, NULL, NULL, '2101', NULL, 'SPORT-货币', NULL, NULL
 WHERE 21014 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21014);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21015', 'action', 'action', 't', NULL, NULL, NULL, '', '2101', NULL, 'SPORT-请求类型', NULL, NULL
 WHERE 21015 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21015);


 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21021', 'userName', 'user.account', 't', NULL, NULL, NULL, '', '2102', '', 'SPORT-用户名', '', ''
 WHERE 21021 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21021);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21022', 'password', 'user.password', 't', NULL, NULL, NULL, '', '2102', '', 'SPORT-密码', '', ''
 WHERE 21022 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21022);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21023', 'bankUrl', 'bankingUrl', 't', NULL, NULL, NULL, '', '2102', '', 'SPORT-充值中心', '', ''
 WHERE 21023 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21023);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21024', 'lobbyUrl', 'lobbyUrl', 't', NULL, NULL, NULL, '', '2102', '', 'SPORT-站点游戏大厅', '', ''
 WHERE 21024 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21024);


 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21031', 'userName', 'userName', 't', NULL, NULL, NULL, '', '2103', '', 'SPORT-用户名', '', ''
 WHERE 21031 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21031);


 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21041', 'userName', 'user.account', 't', NULL, NULL, NULL, '', '2104', '', 'SPORT-用户名', '', ''
 WHERE 21041 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21041);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21042', 'transactionNo', 'transId', 't', NULL, NULL, NULL, '', '2104', '', 'SPORT-交易号', '', ''
 WHERE 21042 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21042);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21043', 'money', 'amount', 't', NULL, NULL, NULL, '', '2104', '', 'SPORT-金额', '', ''
 WHERE 21043 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21043);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21051', 'userName', 'user.account', 't', NULL, NULL, NULL, '', '2105', '', 'SPORT-用户名', '', ''
 WHERE 21051 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21051);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21052', 'transactionNo', 'transId', 't', NULL, NULL, NULL, '', '2105', '', 'SPORT-交易号', '', ''
 WHERE 21052 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21052);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21053', 'money', 'amount', 't', NULL, NULL, NULL, '', '2105', '', 'SPORT-金额', '', ''
 WHERE 21053 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21053);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21061', 'transactionNo', 'transId', 't', NULL, NULL, NULL, '', '2106', '', 'SPORT-交易号', '', ''
 WHERE 21061 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21061);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21062', 'type', 'type', 't', NULL, NULL, NULL, '', '2106', '', 'SPORT-交易类型(1:存款,2:取款)', '', ''
 WHERE 21062 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21062);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21071', 'startDate', 'startTime', 't', NULL, NULL, NULL, NULL, '2107', NULL, 'SPORT-注单开始时间', NULL, NULL
 WHERE 21071 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21071);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21072', 'endDate', 'endTime', 't', NULL, NULL, NULL, NULL, '2107', NULL, 'SPORT-注单开始时间', NULL, NULL
 WHERE 21072 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21072);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21073', 'pageNum', 'pageNum', 't', NULL, NULL, NULL, NULL, '2107', NULL, 'SPORT-当前页数', NULL, NULL
 WHERE 21073 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21073);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '21074', 'pageSize', 'pageSize', 't', NULL, NULL, NULL, NULL, '2107', NULL, 'SPORT-每页记录数', NULL, NULL
 WHERE 21074 NOT IN(SELECT id FROM game_api_interface_request WHERE id=21074);