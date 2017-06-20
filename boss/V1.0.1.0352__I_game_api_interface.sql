-- auto gen by cherry 2017-06-20 09:11:06
INSERT INTO "game_api_provider" ("id", "abbr_name", "full_name", "api_url", "remarks", "jar_url", "api_class", "jar_version", "ext_json", "default_timezone", "support_agent") SELECT '25', 'spade', '', 'http://3rd.game.api.com/spade-api/api/', '测试环境:http://testspadegaming.ampinplayopt0matrix.com', 'file:/data/impl-jars/api/api-spade.jar', 'so.wwb.gamebox.service.gameapi.impl.SpadeGameApi', '201706170606112', '{"merchantCode":"DAWOO","search-minute":"10","validateTokenExpire":60,"gameUrl":"http://api.egame.staging.sgplay.net/dawoo/auth/"}', '+0', 'f' WHERE 25 NOT IN(SELECT id FROM game_api_provider WHERE id=25);

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT '2501', 'HTTP', 'login', 'register', 'POST', 'SPADE-创建账号并登录到游戏平台，若账号已存在则直接登录', 'org.soul.model.gameapi.param.RegisterParam', 'org.soul.model.gameapi.result.LoginResult', 'JSON', 'JSON', '25', '' WHERE 2501 NOT IN(SELECT id FROM game_api_interface WHERE id=2501);

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT '2502', 'HTTP', 'login', 'login', 'POST', 'SPADE-登录到游戏平台', 'org.soul.model.gameapi.param.LoginParam', 'org.soul.model.gameapi.result.LoginResult', 'JSON', 'JSON', '25', '' WHERE 2502 NOT IN(SELECT id FROM game_api_interface WHERE id=2502);

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT '2503', 'HTTP', 'getAcctInfo', 'fetchBalance', 'POST', 'SPADE-获取游戏平台即时余额', 'org.soul.model.gameapi.param.FetchBalanceParam', 'org.soul.model.gameapi.result.FetchBalanceResult', 'JSON', 'JSON', '25', '' WHERE 2503 NOT IN(SELECT id FROM game_api_interface WHERE id=2503);

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT '2504', 'HTTP', 'withdraw', 'withdraw', 'POST', 'SPADE-从游戏平台取款', 'org.soul.model.gameapi.param.WithdrawParam', 'org.soul.model.gameapi.result.WithdrawResult', 'JSON', 'JSON', '25', '' WHERE 2504 NOT IN(SELECT id FROM game_api_interface WHERE id=2504);

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT '2505', 'HTTP', 'deposit', 'deposit', 'POST', 'SPADE-从游戏平台取款', 'org.soul.model.gameapi.param.WithdrawParam', 'org.soul.model.gameapi.result.WithdrawResult', 'JSON', 'JSON', '25', '' WHERE 2505 NOT IN(SELECT id FROM game_api_interface WHERE id=2505);

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT '2506', 'HTTP', 'getBetHistory', 'fetchRecord', 'POST', 'SPADE-从游戏平台获取注单记录', 'org.soul.model.gameapi.param.FetchRecordParam', 'org.soul.model.gameapi.result.FetchRecordResult', 'JSON', 'JSON', '25', '' WHERE 2506 NOT IN(SELECT id FROM game_api_interface WHERE id=2506);

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT '2507', 'HTTP', 'checkStatus', 'checkTransfer', 'POST', 'SPADE-确认转账', 'org.soul.model.gameapi.param.WithdrawParam', 'org.soul.model.gameapi.result.CheckTransferResult', 'JSON', 'JSON', '25', '' WHERE 2507 NOT IN(SELECT id FROM game_api_interface WHERE id=2507);

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT '2508', 'HTTP', 'kickAcct', 'kickOut', 'POST', 'SPADE-踢出玩家', 'org.soul.model.gameapi.param.KickOutParam', 'org.soul.model.gameapi.result.KickOutResult', 'JSON', 'JSON', '25', '' WHERE 2508 NOT IN(SELECT id FROM game_api_interface WHERE id=2508);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25031', 'acctId', 'acctId', 'f', NULL, NULL, '', '', '2503', '', 'SPADE-用户名ID', '', '' WHERE 25031 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25031);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25032', 'pageIndex', 'pageIndex', 't', NULL, NULL, '', '0', '2503', '', 'SPADE-页码', '', '' WHERE 25032 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25032);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25033', 'merchantCode', 'merchantCode', 't', NULL, NULL, '', '', '2503', '', 'SPADE-标识商户 ID', '', '' WHERE 25033 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25033);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25034', 'serialNo', 'transId', 't', NULL, NULL, '', '', '2503', '', 'SPADE-用于标识消息的序列,由调用者生成', '', '' WHERE 25034 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25034);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25041', 'acctId', 'user.account', 't', NULL, NULL, '', '', '2504', '', 'SPADE-用户名ID', '', '' WHERE 25041 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25041);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25042', 'currency', 'user.currency', 't', NULL, NULL, '', '', '2504', '', 'SPADE-货币的 ISO 代码', '', '' WHERE 25042 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25042);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25043', 'amount', 'amount', 't', NULL, NULL, '', '', '2504', '', 'SPADE-取款金额', '', '' WHERE 25043 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25043);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25044', 'serialNo', 'transId', 't', NULL, NULL, '', '', '2504', '', 'SPADE-用于标识消息的序列,由调用者生成', '', '' WHERE 25044 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25044);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25045', 'merchantCode', 'merchantCode', 't', NULL, NULL, '', '', '2504', '', 'SPADE-标识商户 ID', '', '' WHERE 25045 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25045);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25051', 'acctId', 'user.account', 't', NULL, NULL, '', '', '2505', '', 'SPADE-用户名ID', '', '' WHERE 25051 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25051);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25052', 'currency', 'user.currency', 't', NULL, NULL, '', '', '2505', '', 'SPADE-货币的 ISO 代码', '', '' WHERE 25052 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25052);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25053', 'amount', 'amount', 't', NULL, NULL, '', '', '2505', '', 'SPADE-存款金额', '', '' WHERE 25053 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25053);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25054', 'serialNo', 'transId', 't', NULL, NULL, '', '', '2505', '', 'SPADE-用于标识消息的序列,由调用者生成', '', '' WHERE 25054 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25054);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25055', 'merchantCode', 'merchantCode', 't', NULL, NULL, '', '', '2505', '', 'SPADE-标识商户 ID', '', '' WHERE 25055 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25055);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25061', 'beginDate', 'beginDate', 't', NULL, NULL, '', '', '2506', '', 'SPADE-查询注单开始时间', '', '' WHERE 25061 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25061);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25062', 'endDate', 'endDate', 't', NULL, NULL, '', '', '2506', '', 'SPADE-查询注单结束时间', '', '' WHERE 25062 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25062);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25063', 'pageIndex', 'pageIndex', 't', NULL, NULL, '', '', '2506', '', 'SPADE-页码', '', '' WHERE 25063 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25063);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25064', 'merchantCode', 'merchantCode', 't', NULL, NULL, '', '', '2506', '', 'SPADE-标识商户 ID', '', '' WHERE 25064 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25064);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25071', 'lastSerialNo', 'transId', 't', NULL, NULL, '', '', '2507', '', 'SPADE-查询状态的流水号', '', '' WHERE 25071 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25071);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25072', 'merchantCode', 'merchantCode', 't', NULL, NULL, '', '', '2507', '', 'SPADE-标识商户 ID', '', '' WHERE 25072 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25072);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25073', 'serialNo', 'transId', 't', NULL, NULL, '', '', '2507', '', 'SPADE-用于标识消息的序列,由调用者生成', '', '' WHERE 25073 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25073);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25081', 'acctId', 'user.account', 'f', NULL, NULL, '', '', '2508', '', 'SPADE-玩家 ID, 如果为空则退出全部', '', '' WHERE 25081 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25081);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25082', 'merchantCode', 'merchantCode', 't', NULL, NULL, '', '', '2508', '', 'SPADE-标识商户 ID', '', '' WHERE 25082 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25082);

INSERT INTO "game_api_interface_request"("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT '25083', 'serialNo', 'transId', 't', NULL, NULL, '', '', '2508', '', 'SPADE-用于标识消息的序列,由调用者生成', '', '' WHERE 25083 NOT IN(SELECT id FROM game_api_interface_request WHERE id=25083);
INSERT INTO "game_api_interface"("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT '2409', 'HTTP', 'TransactionDetail.API', 'fetchModifiedRecord', 'POST', 'CASINO-修改获取注单', 'org.soul.model.gameapi.param.FetchRecordParam', 'org.soul.model.gameapi.result.FetchRecordResult', 'FORM', 'XML', '24', '' WHERE 2409 NOT IN(SELECT id FROM game_api_interface WHERE id=2409);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24091', 'start_time', 'startTime', 't', NULL, NULL, NULL, NULL, '2409', NULL, 'CASINO-注单开始时间', NULL, NULL
 WHERE 24091 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24091);

  INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24092', 'end_time', 'endTime', 't', NULL, NULL, NULL, NULL, '2409', NULL, 'CASINO-注单结束时间', NULL, NULL
 WHERE 24092 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24092);

  INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24093', 'operator_id', 'operator_id', 't', NULL, NULL, '', '', '2409', '', 'CASINO-operator_id', '', ''
 WHERE 24093 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24093);

  INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24094', 'site_code', 'site_code', 't', NULL, NULL, NULL, '', '2409', '', 'CASINO-site_Code', '', ''
 WHERE 24094 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24094);

  INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24095', 'secret_key', 'secret_key', 't', NULL, NULL, NULL, '', '2409', '', 'CASINO-secretKey', '', ''
 WHERE 24095 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24095);

  INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24096', 'product_code', 'product_code', 't', NULL, NULL, NULL, '', '2409', '', 'CASINO-product_Code', '', ''
 WHERE 24096 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24096);