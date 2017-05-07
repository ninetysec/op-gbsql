-- auto gen by mical 2016-08-01 05:59:20
INSERT INTO "game_api_provider" ("id", "abbr_name", "full_name", "api_url", "remarks", "jar_url", "api_class", "jar_version", "ext_json") VALUES ('11', 'PG', 'PG', 'http://3rd.game.api.com/pg-api/service/PGLotteryHandler.ashx', '正式环境', 'file:/data/impl-jars/api-pg.jar', 'so.wwb.gamebox.service.gameapi.impl.PgGameApi', '20160802020822', '{"apiAccount":"652795","key":"jjvH82hdfLEnmui4pvZJJECWwKC6AuCFVgz8NeF1vIiv1gy20qZbEHPEGzbmpcDL0Yr7UbgaPYd1m8VfcBVavq2drUqd3jBi6wm2","pre_key":"cq_","setNum":"500","search-minute":"5"}');


INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") VALUES ('221', 'HTTP', 'REGISTER', 'register', 'POST', 'PG-创建账号', 'org.soul.model.gameapi.param.RegisterParam', 'org.soul.model.gameapi.result.RegisterResult', 'FORM', 'JSON', '11', '');
INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") VALUES ('222', 'HTTP', 'DEPOSIT', 'deposit', 'POST', 'PG-转账到游戏平台', 'org.soul.model.gameapi.param.DepositParam', 'org.soul.model.gameapi.result.DepositResult', 'FORM', 'JSON', '11', '');
INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") VALUES ('223', 'HTTP', 'LOGIN', 'login', 'POST', 'PG-登录到游戏平台', 'org.soul.model.gameapi.param.LoginParam', 'org.soul.model.gameapi.result.LoginResult', 'FORM', 'JSON', '11', '');
INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") VALUES ('224', 'HTTP', 'WITHDRAW', 'withdraw', 'POST', 'PG-从游戏平台取款', 'org.soul.model.gameapi.param.WithdrawParam', 'org.soul.model.gameapi.result.WithdrawResult', 'FORM', 'JSON', '11', '');
INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") VALUES ('225', 'HTTP', 'GET_BALANCE', 'fetchBalance', 'POST', 'PG-获取游戏平台即时余额', 'org.soul.model.gameapi.param.FetchBalanceParam', 'org.soul.model.gameapi.result.FetchBalanceResult', 'FORM', 'JSON', '11', '');
INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") VALUES ('226', 'HTTP', 'GET_RECORD', 'fetchRecord', 'POST', 'PG-获取游戏平台注单', 'org.soul.model.gameapi.param.FetchRecordParam', 'org.soul.model.gameapi.result.FetchRecordResult', 'FORM', 'JSON', '11', '');
INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") VALUES ('227', 'HTTP', 'GET_ADJUSTED_RECORD', 'fetchModifiedRecord', 'POST', 'PG-获取游戏平台修改游戏局影响的注单ID', 'org.soul.model.gameapi.param.FetchModifiedRecordParam', 'org.soul.model.gameapi.result.FetchModifiedRecordResult', 'FORM', 'JSON', '11', '');
INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") VALUES ('228', 'HTTP', 'CHECK_REF', 'checkTransfer', 'POST', 'PG-验证存取款交易号是否已经处理', 'org.soul.model.gameapi.param.CheckTransferParam', 'org.soul.model.gameapi.result.CheckTransferResult', 'FORM', 'JSON', '11', '');



INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1000', 'userName', 'user.account', 't', NULL, NULL, '', '', '221', '', 'PG-玩家在游戏平台的帐号', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1001', 'nick', 'user.nickname', 't', '1', '20', '', '', '221', '', 'PG-玩家在游戏平台的昵称', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1002', 'password', 'user.password', 't', NULL, NULL, '', '', '221', '', 'PG-玩家在游戏平台的帐号密码', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1003', 'apiAccount', 'apiAccount', 't', NULL, NULL, '', '', '221', '', 'PG-商户号', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1004', 'agentUserName', 'agentUserName', 'f', NULL, NULL, '', '', '221', '', 'PG-此用户的上级代理用户名', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1005', 'userType', 'userType', 'f', NULL, NULL, '', '2', '221', '', 'PG-用户类型 1=代理  2=普通会员', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1006', 'code', 'code', 't', NULL, NULL, '', '', '221', '', 'PG-验证码', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1007', 'action', 'action', 't', NULL, NULL, '', 'register', '221', '', 'PG-请求方法', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1010', 'userName', 'user.account', 't', NULL, NULL, '', '', '222', '', 'PG-玩家在游戏平台的帐号', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1011', 'apiAccount', 'apiAccount', 't', NULL, NULL, '', '', '222', '', 'PG-商户号', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1012', 'code', 'code', 't', NULL, NULL, '', '', '222', '', 'PG-验证码', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1013', 'amount', 'amount', 't', NULL, NULL, '', '', '222', '', 'PG-转账金额', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1014', 'action', 'action', 't', NULL, NULL, '', '', '222', '', 'PG-请求方法', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1015', 'orderNum', 'api_transId', 't', NULL, NULL, '', '', '222', '', 'PG-唯一交易号', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1020', 'userName', 'user.account', 't', NULL, NULL, '', '', '224', '', 'PG-玩家在游戏平台的帐号', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1021', 'apiAccount', 'apiAccount', 't', NULL, NULL, '', '', '224', '', 'PG-商户号', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1022', 'code', 'code', 't', NULL, NULL, '', '', '224', '', 'PG-验证码', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1023', 'amount', 'amount', 't', NULL, NULL, '', '', '224', '', 'PG-转账金额', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1024', 'action', 'action', 't', NULL, NULL, '', 'withdrawal', '224', '', 'PG-请求方法', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1025', 'orderNum', 'api_transId', 't', NULL, NULL, '', '', '224', '', 'PG-唯一交易号', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1030', 'userName', 'user.account', 't', NULL, NULL, '', '', '223', '', 'PG-玩家在游戏平台的帐号', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1031', 'apiAccount', 'apiAccount', 't', NULL, NULL, '', '', '223', '', 'PG-商户号', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1032', 'code', 'code', 't', NULL, NULL, '', '', '223', '', 'PG-验证码', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1033', 'lotteryType', 'lotteryType', 'f', NULL, NULL, '', '', '223', '', 'PG-彩票类型，默认显示重庆时时彩', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1034', 'action', 'api_action', 't', NULL, NULL, '', 'loginIn', '223', '', 'PG-请求方法', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1035', 'password', 'user.password', 't', NULL, NULL, '', '', '223', '', 'PG-玩家在游戏平台的帐号密码', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1040', 'userName', 'userName', 't', NULL, NULL, '', '', '225', '', 'PG-玩家在游戏平台的帐号', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1041', 'apiAccount', 'apiAccount', 't', NULL, NULL, '', '', '225', '', 'PG-商户号', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1042', 'code', 'code', 't', NULL, NULL, '', '', '225', '', 'PG-验证码', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1044', 'action', 'action', 't', NULL, NULL, '', 'balance', '225', '', 'PG-请求方法', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1050', 'userName', 'userName', 'f', NULL, NULL, '', '', '226', '', 'PG-用户名', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1051', 'apiAccount', 'apiAccount', 't', NULL, NULL, '', '', '226', '', 'PG-商户号', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1052', 'code', 'code', 't', NULL, NULL, '', '', '226', '', 'PG-验证码', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1053', 'action', 'action', 't', NULL, NULL, '', 'records', '226', '', 'PG-请求方法', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1054', 'endTime', 'endTime', 't', NULL, NULL, '', '', '226', '', 'PG-查询结束时间', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1055', 'startTime', 'startTime', 't', NULL, NULL, '', '', '226', '', 'PG-查询的开始时间', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1056', 'termNum', 'termNum', 'f', NULL, NULL, '', '', '226', '', 'PG-彩票期号', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1057', 'lotteryType', 'lotteryType', 'f', NULL, NULL, '', '0', '226', '', 'PG-彩票种类', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1058', 'orderState', 'orderState', 't', NULL, NULL, '', '0', '226', '', 'PG-订单状态', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1059', 'orderNum', 'orderNum', 'f', NULL, NULL, '', '', '226', '', 'PG-交易流水号', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1060', 'pageIndex', 'pageIndex', 't', NULL, NULL, '', '1', '226', '', 'PG-当前页码索引', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1061', 'pageSize', 'pageSize', 't', NULL, NULL, '', '1000', '226', '', 'PG-每页数量', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1070', 'userName', 'userName', 'f', NULL, NULL, '', '', '227', '', 'PG-用户名', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1071', 'apiAccount', 'apiAccount', 't', NULL, NULL, '', '', '227', '', 'PG-商户号', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1072', 'code', 'code', 't', NULL, NULL, '', '', '227', '', 'PG-验证码', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1073', 'action', 'action', 't', NULL, NULL, '', 'records', '227', '', 'PG-请求方法', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1074', 'osEndTime', 'endTime', 't', NULL, NULL, '', '', '227', '', 'PG-查询结束时间', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1075', 'osStartTime', 'startTime', 't', NULL, NULL, '', '', '227', '', 'PG-查询的开始时间', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1076', 'termNum', 'termNum', 'f', NULL, NULL, '', '', '227', '', 'PG-彩票期号', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1077', 'lotteryType', 'lotteryType', 'f', NULL, NULL, '', '0', '227', '', 'PG-彩票种类', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1078', 'orderState', 'orderState', 't', NULL, NULL, '', '0', '227', '', 'PG-订单状态', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1079', 'orderNum', 'orderNum', 'f', NULL, NULL, '', '', '227', '', 'PG-交易流水号', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1080', 'pageIndex', 'pageIndex', 't', NULL, NULL, '', '1', '227', '', 'PG-当前页码索引', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1081', 'pageSize', 'pageSize', 't', NULL, NULL, '', '1000', '227', '', 'PG-每页数量', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1091', 'apiAccount', 'apiAccount', 't', NULL, NULL, '', '', '228', '', 'PG-商户号', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1092', 'code', 'code', 't', NULL, NULL, '', '', '228', '', 'PG-验证码', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1093', 'action', 'action', 't', NULL, NULL, '', 'queryState', '228', '', 'PG-请求方法', '', '');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('1094', 'orderNum', 'api_transId', 't', NULL, NULL, '', '', '228', '', 'PG-交易号', '', '');
