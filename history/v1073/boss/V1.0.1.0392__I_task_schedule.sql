-- auto gen by cherry 2017-07-31 16:09:23

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class", "belong_to_idc", "scheduler")
SELECT  'apiId-27-DREAMTECH-新增下单记录', NULL, NULL, 'so.wwb.gamebox.service.company.PlayerGameOrderFetchJob', 'execute', 't', '1', '0 0/4 * * * ?', 't', 'api任务', '2017-05-24 02:13:48.132917', NULL, 'api-27-I', 'f', 'f', '27', 'java.lang.Integer', 'A', 'scheduler4Api'
WHERE not EXISTS(SELECT job_code FROM task_schedule where job_code='api-27-I');


INSERT INTO "game_api_provider" ("id", "abbr_name", "full_name", "api_url", "remarks", "jar_url", "api_class", "jar_version", "ext_json", "default_timezone", "support_agent") SELECT '27', 'DT', '', 'http://3rd.game.api.com/dt-api/dtApi.html', '', 'file:/data/impl-jars/api/api-dt.jar', 'so.wwb.gamebox.service.gameapi.impl.DtGameApi', '20170707071010', '{"BUSINESS":"NNTI_AVIA_DAWOO","APIKEY":"sdY22Jj6OJj6Isuj6I33UIX6","PAGENUMBER":"1","PAGESIZE":"20","search-minute":"10"}', '+0', 'f'  WHERE 27 NOT IN(SELECT id FROM game_api_provider WHERE id=27);



INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT '2701', 'HTTP', 'CREATE', 'register', 'GET', 'DT-创建账号', 'org.soul.model.gameapi.param.RegisterParam', 'org.soul.model.gameapi.result.LoginResult', 'JSON', 'JSON', '27', '' WHERE 2701 NOT IN(SELECT id FROM game_api_interface WHERE id=2701);



INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT '2702', 'HTTP', 'LOGIN', 'login', 'GET', 'DT-登录到游戏平台', 'org.soul.model.gameapi.param.LoginParam', 'org.soul.model.gameapi.result.LoginResult', 'JSON', 'JSON', '27', '{"isfun":"0"}' WHERE 2702 NOT IN(SELECT id FROM game_api_interface WHERE id=2702);


INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT '2703', 'HTTP', 'GETAMOUNT', 'fetchBalance', 'GET', 'DT-获取游戏平台即时余额', 'org.soul.model.gameapi.param.FetchBalanceParam', 'org.soul.model.gameapi.result.FetchBalanceResult', 'JSON', 'JSON', '27', '' WHERE 2703 NOT IN(SELECT id FROM game_api_interface WHERE id=2703);


INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT '2704', 'HTTP', 'WITHDRAW', 'withdraw', 'GET', 'DT-从游戏平台取款', 'org.soul.model.gameapi.param.WithdrawParam', 'org.soul.model.gameapi.result.WithdrawResult', 'JSON', 'JSON', '27', '' WHERE 2704 NOT IN(SELECT id FROM game_api_interface WHERE id=2704);


INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT '2705', 'HTTP', 'DEPOSIT', 'deposit', 'GET', 'DT-从游戏平台存款', 'org.soul.model.gameapi.param.WithdrawParam', 'org.soul.model.gameapi.result.WithdrawResult', 'JSON', 'JSON', '27', '' WHERE 2705 NOT IN(SELECT id FROM game_api_interface WHERE id=2705);



INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT '2706', 'HTTP', 'GETBETDETAIL', 'fetchRecord', 'GET', 'DT-从游戏平台获取注单记录', 'org.soul.model.gameapi.param.FetchRecordParam', 'org.soul.model.gameapi.result.FetchRecordResult', 'JSON', 'JSON', '27', '' WHERE 2706 NOT IN(SELECT id FROM game_api_interface WHERE id=2706);


INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT '2707', 'HTTP', 'CHECKTRANSFER', 'checkTransfer', 'GET', 'DT-确认转账', 'org.soul.model.gameapi.param.WithdrawParam', 'org.soul.model.gameapi.result.CheckTransferResult', 'JSON', 'JSON', '27', '' WHERE 2707 NOT IN(SELECT id FROM game_api_interface WHERE id=2707);




INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27011', 'METHOD', 'METHOD', 't', NULL, NULL, '', '', '2701', '', 'DT-请求接口的方法', '', '' WHERE 27011 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27011);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27012', 'BUSINESS', 'BUSINESS', 't', NULL, NULL, '', '', '2701', '', 'DT-商户号', '', '' WHERE 27012 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27012);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27013', 'PLAYERNAME', 'user.account', 't', NULL, NULL, '', '', '2701', '', 'DT-玩家账号， 需转换成大写', '', '' WHERE 27013 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27013);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27014', 'PLAYERPASSWORD', 'user.password', 't', NULL, NULL, '', '', '2701', '', 'DT-玩家密码', '', '' WHERE 27014 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27014);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27015', 'SIGNATURE', 'SIGNATURE', 't', NULL, NULL, '', '', '2701', '', 'DT-MD5 加密， SIGNATURE 的值为 MD5 加密， 加密顺序为 BUSINESS + METHOD +PLAYERNAME + PLAYERPASSWORD +APIKEY', '', '' WHERE 27015 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27015);




INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27021', 'METHOD', 'METHOD', 't', NULL, NULL, '', '', '2702', '', 'DT-请求接口的方法', '', '' WHERE 27021 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27021);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27022', 'BUSINESS', 'BUSINESS', 't', NULL, NULL, '', '', '2702', '', 'DT-商户号', '', '' WHERE 27022 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27022);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27023', 'PLAYERNAME', 'user.account', 't', NULL, NULL, '', '', '2702', '', 'DT-玩家账号， 需转换成大写', '', '' WHERE 27023 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27023);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27024', 'PLAYERPASSWORD', 'user.password', 't', NULL, NULL, '', '', '2702', '', 'DT-玩家密码', '', '' WHERE 27024 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27024);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27025', 'SIGNATURE', 'SIGNATURE', 't', NULL, NULL, '', '', '2702', '', 'DT-MD5 加密， SIGNATURE 的值为 MD5 加密， 加密顺序为 BUSINESS + METHOD +PLAYERNAME + PLAYERPASSWORD +APIKEY', '', '' WHERE 27025 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27025);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27031', 'METHOD', 'METHOD', 't', NULL, NULL, '', '', '2703', '', 'DT-请求接口的方法', '', '' WHERE 27031 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27031);


INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27032', 'BUSINESS', 'BUSINESS', 't', NULL, NULL, '', '', '2703', '', 'DT-商户号', '', '' WHERE 27032 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27032);


INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27033', 'PLAYERNAME', 'PLAYERNAME', 't', NULL, NULL, '', '', '2703', '', 'DT-玩家账号， 需转换成大写', '', '' WHERE 27033 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27033);


INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27034', 'SIGNATURE', 'SIGNATURE', 't', NULL, NULL, '', '', '2703', '', 'DT-MD5 加密， SIGNATURE 的值为 MD5 加密， 加密顺序为 BUSINESS +METHOD + PLAYERNAME+ APIKEY', '', '' WHERE 27034 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27034);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27041', 'METHOD', 'METHOD', 't', NULL, NULL, '', '', '2704', '', 'DT-请求接口的方法', '', '' WHERE 27041 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27041);


INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27042', 'BUSINESS', 'BUSINESS', 't', NULL, NULL, '', '', '2704', '', 'DT-商户号', '', '' WHERE 27042 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27042);


INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27043', 'PLAYERNAME', 'user.account', 't', NULL, NULL, '', '', '2704', '', 'DT-玩家账号， 需转换成大写', '', '' WHERE 27043 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27043);


INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27044', 'PRICE', 'amount', 't', NULL, NULL, '', '', '2704', '', 'DT-转入金额， 最多保留两位小数， 不能小于 0', '', '' WHERE 27044 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27044);


INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27045', 'TRANSFER_ID', 'transId', 't', NULL, NULL, '', '', '2704', '', 'DT-商户系统的唯一转账 id', '', '' WHERE 27045 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27045);


INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27046', 'SIGNATURE', 'SIGNATURE', 't', NULL, NULL, '', '', '2704', '', 'DT-MD5 加密， SIGNATURE 的值为 MD5 加密， 加密顺序为 BUSINESS +METHOD + PLAYERNAME + PRICE +APIKEY', '', '' WHERE 27046 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27046);






INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27051', 'METHOD', 'METHOD', 't', NULL, NULL, '', '', '2705', '', 'DT-请求接口的方法', '', '' WHERE 27051 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27051);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27052', 'BUSINESS', 'BUSINESS', 't', NULL, NULL, '', '', '2705', '', 'DT-商户号', '', '' WHERE 27052 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27052);


INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27053', 'PLAYERNAME', 'user.account', 't', NULL, NULL, '', '', '2705', '', 'DT-玩家账号， 需转换成大写', '', '' WHERE 27053 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27053);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27054', 'PRICE', 'amount', 't', NULL, NULL, '', '', '2705', '', 'DT-转入金额， 最多保留两位小数， 不能小于 0', '', '' WHERE 27054 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27054);


INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27055', 'TRANSFER_ID', 'transId', 't', NULL, NULL, '', '', '2705', '', 'DT-商户系统的唯一转账 id', '', '' WHERE 27055 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27055);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27056', 'SIGNATURE', 'SIGNATURE', 't', NULL, NULL, '', '', '2705', '', 'DT-MD5 加密， SIGNATURE 的值为 MD5 加密， 加密顺序为 BUSINESS +METHOD + PLAYERNAME + PRICE +APIKEY', '', '' WHERE 27056 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27056);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27061', 'METHOD', 'METHOD', 't', NULL, NULL, '', '', '2706', '', 'DT-请求接口的方法', '', '' WHERE 27061 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27061);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27062', 'BUSINESS', 'BUSINESS', 't', NULL, NULL, '', '', '2706', '', 'DT-商户号', '', '' WHERE 27062 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27062);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27063', 'PLAYERNAME', 'PLAYERNAME', 'f', NULL, NULL, '', '', '2706', '', 'DT-查询明细的开始时间,格式：yyyy-MM-ddHH:mm:ss', '', '' WHERE 27063 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27063);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27064', 'START_TIME', 'START_TIME', 't', NULL, NULL, '', '', '2706', '', 'DT-查询明细的开始时间,格式：yyy-MM-ddHH:mm:ss', '', '' WHERE 27064 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27064);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27065', 'END_TIME', 'END_TIME', 't', NULL, NULL, '', '', '2706', '', 'DT-查询明细的截止时间:yyy-MM-ddHH:mm:ss', '', '' WHERE 27065 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27065);
INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27066', 'PAGENUMBER', 'PAGENUMBER', 't', NULL, NULL, '', '', '2706', '', 'DT-查询页码', '', '' WHERE 27066 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27066);
INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27067', 'PAGESIZE', 'PAGESIZE', 't', NULL, NULL, '', '', '2706', '', 'DT-查询请求行数', '', '' WHERE 27067 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27067);
INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27068', 'SIGNATURE', 'SIGNATURE', 't', NULL, NULL, '', '', '2706', '', 'DT-MD5 加密， SIGNATURE 的值为 MD5 加密， 加密顺序为BUSINESS+METHOD+PLAYERNAME+START_TIME+END_TIME+ APIKEY', '', '' WHERE 27068 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27068);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27071', 'METHOD', 'METHOD', 't', NULL, NULL, '', '', '2707', '', 'DT-请求接口的方法', '', '' WHERE 27071 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27071);



INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27072', 'BUSINESS', 'BUSINESS', 't', NULL, NULL, '', '', '2707', '', 'DT-商户号', '', '' WHERE 27072 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27072);


INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27073', 'TRANSFER_ID', 'transId', 't', NULL, NULL, '', '', '2707', '', 'DT-商户系统的唯一转账 id', '', '' WHERE 27073 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27073);


INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '27074', 'SIGNATURE', 'SIGNATURE', 't', NULL, NULL, '', '', '2707', '', 'DT-MD5 加密， SIGNATURE 的值为 MD5 加密， 加密顺序为 BUSINESS +METHOD +TRANSFER_ID + APIKEY', '', '' WHERE 27074 NOT IN(SELECT id FROM game_api_interface_request WHERE id=27074);


