-- auto gen by cherry 2017-06-06 10:50:55
INSERT INTO "game_api_provider" ("id", "abbr_name", "full_name", "api_url", "remarks", "jar_url", "api_class", "jar_version", "ext_json", "default_timezone", "support_agent")
SELECT '24', 'opuscasino', NULL, 'http://3rd.game.api.com/opuscasino-api/', '测试环境:http://testopuscasinotoken.ampinplayopt0matrix.com/api/', 'file:/data/impl-jars/api/api-opuscasino.jar', 'so.wwb.gamebox.service.gameapi.impl.CasinoGameApi', '201705301555', '{"operator_id":"4C936EDA-6C77-4A46-B55F-D97AFA63B338","site_code":"DAP","secret_key":"862B05FA0F62","product_code":"mcasino","gameUrl":"http://testopuscasino.ampinplayopt0matrix.com", "loginUrl": "http://testopuscasinotoken.ampinplayopt0matrix.com/api/opus/login.html?key={0}","domain":"ampinplayopt0matrix.com","validateTokenExpire":60,"membertype":"CASH","min_transfer":"0","max_transfer":"100000","search-minute":"10"}', '+0', 'f'
 WHERE 24 NOT IN(SELECT id FROM game_api_provider WHERE id=24);



 INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
  SELECT '2401', 'HTTP', 'CreateMember.API', 'register', 'POST', 'CASINO-创建账号', 'org.soul.model.gameapi.param.RegisterParam', 'org.soul.model.gameapi.result.RegisterResult', 'FORM', 'XML', '24', NULL
  WHERE 2401 NOT IN(SELECT id FROM game_api_interface WHERE id=2401);


INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
  SELECT '2402', 'HTTP', 'http://testopuscasino.ampinplayopt0matrix.com', 'login', 'POST', 'CASINO-登录到游戏平台', 'org.soul.model.gameapi.param.LoginParam', 'org.soul.model.gameapi.result.LoginResult', 'FORM', 'XML', '24', NULL
  WHERE 2402 NOT IN(SELECT id FROM game_api_interface WHERE id=2402);


INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
  SELECT '2403', 'HTTP', 'MemberBalance.API', 'fetchBalance', 'POST', 'CASINO-获取游戏平台即时余额', 'org.soul.model.gameapi.param.FetchBalanceParam', 'org.soul.model.gameapi.result.FetchBalanceResult', 'FORM', 'XML', '24', NULL
  WHERE 2403 NOT IN(SELECT id FROM game_api_interface WHERE id=2403);


INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
  SELECT '2404', 'HTTP', 'DebitBalance.API', 'withdraw', 'POST', 'CASINO-从游戏平台取款', 'org.soul.model.gameapi.param.WithdrawParam', 'org.soul.model.gameapi.result.WithdrawResult', 'FORM', 'XML', '24', NULL
  WHERE 2404 NOT IN(SELECT id FROM game_api_interface WHERE id=2404);


INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
  SELECT '2405', 'HTTP', 'CreditBalance.API', 'deposit', 'POST', 'CASINO-从游戏平台存款', 'org.soul.model.gameapi.param.WithdrawParam', 'org.soul.model.gameapi.result.DepositResult', 'FORM', 'XML', '24', NULL
  WHERE 2405 NOT IN(SELECT id FROM game_api_interface WHERE id=2405);


INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
  SELECT '2406', 'HTTP', 'CheckFundTransferStatus.API', 'checkTransfer', 'POST', 'CASINO-确认转账', 'org.soul.model.gameapi.param.WithdrawParam', 'org.soul.model.gameapi.result.CheckTransferResult', 'FORM', 'XML', '24', NULL
  WHERE 2406 NOT IN(SELECT id FROM game_api_interface WHERE id=2406);


INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
  SELECT '2407', 'HTTP', 'TransactionDetail.API', 'fetchRecord', 'POST', 'CASINO-获取注单', 'org.soul.model.gameapi.param.FetchRecordParam', 'org.soul.model.gameapi.result.FetchRecordResult', 'FORM', 'XML', '24', NULL
  WHERE 2407 NOT IN(SELECT id FROM game_api_interface WHERE id=2407);


INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
  SELECT '2408', 'HTTP', 'KickOutMember.API', 'kickOut', 'POST', 'CASINO-踢出玩家', 'org.soul.model.gameapi.param.KickOutParam', 'org.soul.model.gameapi.result.KickOutResult', 'FORM', 'XML', '24', NULL
  WHERE 2408 NOT IN(SELECT id FROM game_api_interface WHERE id=2408);






INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24011', 'member_id', 'user.account', 't', NULL, NULL, NULL, '', '2401', '', 'CASINO-用户名ID', '', ''
 WHERE 24011 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24011);


INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24012', 'Currency', 'user.currency', 't', NULL, NULL, NULL, NULL, '2401', NULL, 'CASINO-货币', NULL, NULL
 WHERE 24012 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24012);


INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24013', 'Language', 'user.locale', 't', NULL, NULL, NULL, NULL, '2401', NULL, 'CASINO-语言', NULL, NULL
 WHERE 24013 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24013);


INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24014', 'operator_id', 'operator_id', 't', NULL, NULL, NULL, '', '2401', '', 'CASINO-operator_id', '', ''
 WHERE 24014 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24014);


INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24015', 'site_code', 'site_code', 't', NULL, NULL, NULL, '', '2401', '', 'CASINO-site_Code', '', ''
 WHERE 24015 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24015);


INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24016', 'secret_key', 'secret_key', 't', NULL, NULL, NULL, '', '2401', '', 'CASINO-secretKey', '', ''
 WHERE 24016 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24016);


INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24017', 'product_code', 'product_code', 't', NULL, NULL, NULL, '', '2401', '', 'CASINO-product_Code', '', ''
 WHERE 24017 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24017);




INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24021', 'user_name', 'user.account', 't', NULL, NULL, '', '', '2402', '', 'OPUS-CASINO-用户名', '', ''
 WHERE 24021 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24021);


 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24022', 'lang', 'user.locale', 't', NULL, NULL, '', '', '2402', '', 'OPUS-CASINO-游戏语言', '', ''
 WHERE 24022 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24022);




 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24031', 'member_id', 'member_id', 't', NULL, NULL, NULL, '', '2403', '', 'CASINO-用户名ID', '', ''
 WHERE 24031 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24031);


 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24032', 'operator_id', 'operator_id', 't', NULL, NULL, NULL, '', '2403', '', 'CASINO-operator_id', '', ''
 WHERE 24032 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24032);


INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24033', 'site_code', 'site_code', 't', NULL, NULL, NULL, '', '2403', '', 'CASINO-site_Code', '', ''
 WHERE 24033 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24033);


 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24034', 'secret_key', 'secret_key', 't', NULL, NULL, NULL, '', '2403', '', 'CASINO-secretKey', '', ''
 WHERE 24034 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24034);


 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24035', 'product_code', 'product_code', 't', NULL, NULL, NULL, '', '2403', '', 'CASINO-product_Code', '', ''
 WHERE 24035 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24035);



 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24041', 'member_id', 'user.account', 't', NULL, NULL, NULL, '', '2404', '', 'CASINO-用户名ID', '', ''
 WHERE 24041 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24041);


 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24042', 'Currency', 'user.currency', 't', NULL, NULL, NULL, NULL, '2404', NULL, 'CASINO-货币', NULL, NULL
 WHERE 24042 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24042);


 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24043', 'amount', 'amount', 't', NULL, NULL, NULL, '', '2404', '', 'CASINO-金额', '', ''
 WHERE 24043 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24043);


 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24044', 'reference_id', 'transId', 't', NULL, NULL, NULL, '', '2404', '', 'CASINO-交易号', '', ''
 WHERE 24044 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24044);


 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24045', 'remark', 'remark', 'f', NULL, NULL, NULL, '', '2404', '', 'CASINO-转移原因', '', ''
 WHERE 24045 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24045);


 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24046', 'operator_id', 'operator_id', 't', NULL, NULL, NULL, '', '2404', '', 'CASINO-operator_id', '', ''
 WHERE 24046 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24046);


  INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24047', 'site_code', 'site_code', 't', NULL, NULL, NULL, '', '2404', '', 'CASINO-site_Code', '', ''
 WHERE 24047 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24047);


  INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24048', 'secret_key', 'secret_key', 't', NULL, NULL, NULL, '', '2404', '', 'CASINO-secretKey', '', ''
 WHERE 24048 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24048);


 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24049', 'product_code', 'product_code', 't', NULL, NULL, NULL, '', '2404', '', 'CASINO-product_Code', '', ''
 WHERE 24049 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24049);



 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24051', 'member_id', 'user.account', 't', NULL, NULL, NULL, '', '2405', '', 'CASINO-用户名ID', '', ''
 WHERE 24051 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24051);



 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24052', 'Currency', 'user.currency', 't', NULL, NULL, NULL, NULL, '2405', NULL, 'CASINO-货币', NULL, NULL
 WHERE 24052 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24052);



 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24053', 'amount', 'amount', 't', NULL, NULL, NULL, '', '2405', '', 'CASINO-金额', '', ''
 WHERE 24053 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24053);



 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24054', 'reference_id', 'transId', 't', NULL, NULL, NULL, '', '2405', '', 'CASINO-交易号', '', ''
 WHERE 24054 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24054);



 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24055', 'remark', 'remark', 'f', NULL, NULL, NULL, '', '2405', '', 'CASINO-转移原因', '', ''
 WHERE 24055 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24055);



 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24056', 'operator_id', 'operator_id', 't', NULL, NULL, NULL, '', '2405', '', 'CASINO-operator_id', '', ''
 WHERE 24056 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24056);



 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24057', 'site_code', 'site_code', 't', NULL, NULL, NULL, '', '2405', '', 'CASINO-site_Code', '', ''
 WHERE 24057 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24057);



 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24058', 'secret_key', 'secret_key', 't', NULL, NULL, NULL, '', '2405', '', 'CASINO-secretKey', '', ''
 WHERE 24058 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24058);



 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24059', 'product_code', 'product_code', 't', NULL, NULL, NULL, '', '2405', '', 'CASINO-product_Code', '', ''
 WHERE 24059 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24059);



 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24061', 'member_id', 'user.account', 't', NULL, NULL, NULL, '', '2406', '', 'CASINO-用户名ID', '', ''
 WHERE 24061 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24061);


 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24062', 'reference_id', 'transId', 't', NULL, NULL, NULL, '', '2406', '', 'CASINO-交易号', '', ''
 WHERE 24062 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24062);


 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24063', 'operator_id', 'operator_id', 't', NULL, NULL, NULL, '', '2406', '', 'CASINO-operator_id', '', ''
 WHERE 24063 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24063);


 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24064', 'site_code', 'site_code', 't', NULL, NULL, NULL, '', '2406', '', 'CASINO-site_Code', '', ''
 WHERE 24064 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24064);


 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24065', 'secret_key', 'secret_key', 't', NULL, NULL, NULL, '', '2406', '', 'CASINO-secretKey', '', ''
 WHERE 24065 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24065);


 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24066', 'product_code', 'product_code', 't', NULL, NULL, NULL, '', '2406', '', 'CASINO-product_Code', '', ''
 WHERE 24066 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24066);


 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24071', 'start_time', 'startTime', 't', NULL, NULL, NULL, NULL, '2407', NULL, 'CASINO-注单开始时间', NULL, NULL
 WHERE 24071 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24071);


  INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24072', 'end_time', 'endTime', 't', NULL, NULL, NULL, NULL, '2407', NULL, 'CASINO-注单结束时间', NULL, NULL
 WHERE 24072 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24072);


  INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24073', 'operator_id', 'operator_id', 't', NULL, NULL, '', '', '2407', '', 'CASINO-operator_id', '', ''
 WHERE 24073 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24073);


  INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24074', 'site_code', 'site_code', 't', NULL, NULL, NULL, '', '2407', '', 'CASINO-site_Code', '', ''
 WHERE 24074 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24074);


  INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24075', 'secret_key', 'secret_key', 't', NULL, NULL, NULL, '', '2407', '', 'CASINO-secretKey', '', ''
 WHERE 24075 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24075);


  INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24076', 'product_code', 'product_code', 't', NULL, NULL, NULL, '', '2407', '', 'CASINO-product_Code', '', ''
 WHERE 24076 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24076);


  INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24081', 'member_id', 'user.account', 't', NULL, NULL, NULL, '', '2408', '', 'CASINO-用户名ID', '', ''
 WHERE 24081 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24081);



  INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24082', 'operator_id', 'operator_id', 't', NULL, NULL, NULL, '', '2408', '', 'CASINO-operator_id', '', ''
 WHERE 24082 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24082);



  INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24083', 'site_code', 'site_code', 't', NULL, NULL, NULL, '', '2408', '', 'CASINO-site_Code', '', ''
 WHERE 24083 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24083);



  INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24084', 'secret_key', 'secret_key', 't', NULL, NULL, NULL, '', '2408', '', 'CASINO-secretKey', '', ''
 WHERE 24084 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24084);



  INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '24085', 'product_code', 'product_code', 't', NULL, NULL, NULL, '', '2408', '', 'CASINO-product_Code', '', ''
 WHERE 24085 NOT IN(SELECT id FROM game_api_interface_request WHERE id=24085);
INSERT INTO "game_api_provider" ("id", "abbr_name", "full_name", "api_url", "remarks", "jar_url", "api_class", "jar_version", "ext_json", "default_timezone", "support_agent") SELECT '23', 'opussport', NULL, 'http://3rd.game.api.com/opussport-api/', '测试环境:http://testopussporttoken.ampinplayopt0matrix.com/api/', 'file:/data/impl-jars/api/api-opussport.jar', 'so.wwb.gamebox.service.gameapi.impl.OpusSportGameApi', '20170602120611', '{"operator_id":"4C936EDA-6C77-4A46-B55F-D97AFA63B338","site_code":"DAP","secret_key":"862B05FA0F62","product_code":"sb2","search-minute":"10","loginUrl":"http://testopussporttoken.ampinplayopt0matrix.com/api/opus/login.html","domain":"opussport.ampinplayopt0matrix.com","gameUrl":"http://testopussport.ampinplayopt0matrix.com","validateTokenExpire":60,"membertype":"CASH","min_transfer":"0","max_transfer":"100000"}', '+0', 'f'  WHERE 23 NOT IN(SELECT id FROM game_api_provider WHERE id=23);

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT  '2308', 'HTTP', '', 'login', 'POST', 'OPUS-SPORT-登录到游戏平台', 'org.soul.model.gameapi.param.LoginParam', 'org.soul.model.gameapi.result.LoginResult', 'FORM', 'XML', '23', ''
WHERE 2308 NOT IN(SELECT id FROM game_api_interface WHERE id=2308);

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT  '2302', 'HTTP', 'KickUser.API', 'kickOut', 'POST', 'OPUS-SPORT踢出玩家', 'org.soul.model.gameapi.param.KickOutParam', 'org.soul.model.gameapi.result.KickOutResult', 'FORM', 'XML', '23', NULL
WHERE 2302 NOT IN(SELECT id FROM game_api_interface WHERE id=2302);

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT  '2301', 'HTTP', 'CreateMember.API', 'register', 'POST', 'OPUS-SPORT创建账号', 'org.soul.model.gameapi.param.RegisterParam', 'org.soul.model.gameapi.result.RegisterResult', 'FORM', 'XML', '23', NULL
WHERE 2301 NOT IN(SELECT id FROM game_api_interface WHERE id=2301);

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT  '2303', 'HTTP', 'CheckUserBalance.API', 'fetchBalance', 'POST', 'OPUS-SPORT-获取游戏平台即时余额', 'org.soul.model.gameapi.param.FetchBalanceParam', 'org.soul.model.gameapi.result.FetchBalanceResult', 'FORM', 'XML', '23', ''  WHERE 2303 NOT IN(SELECT id FROM game_api_interface WHERE id=2303);
INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT  '2304', 'HTTP', 'FundTransfer.API', 'deposit', 'POST', 'OPUS-SPORT-从游戏平台存款', 'org.soul.model.gameapi.param.WithdrawParam', 'org.soul.model.gameapi.result.DepositResult', 'FORM', 'XML', '23', ''
WHERE 2304 NOT IN(SELECT id FROM game_api_interface WHERE id=2304);

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT  '2307', 'HTTP', 'TransactionMemberDetail.API', 'fetchRecord', 'POST', 'OPUS-SPORT-获取注单', 'org.soul.model.gameapi.param.FetchRecordParam', 'org.soul.model.gameapi.result.FetchRecordResult', 'FORM', 'XML', '23', '' WHERE 2307 NOT IN(SELECT id FROM game_api_interface WHERE id=2307);
INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT  '2305', 'HTTP', 'FundTransfer.API', 'withdraw', 'POST', 'OPUS-SPORT-从游戏平台取款', 'org.soul.model.gameapi.param.WithdrawParam', 'org.soul.model.gameapi.result.WithdrawResult', 'FORM', 'XML', '23', ''
WHERE 2305 NOT IN(SELECT id FROM game_api_interface WHERE id=2305);

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json") SELECT  '2306', 'HTTP', 'CheckFundTransferStatus.API', 'checkTransfer', 'POST', 'OPUS-SPORT-检查转账是否成功', 'org.soul.model.gameapi.param.CheckTransferParam', 'org.soul.model.gameapi.result.CheckTransferResult', 'FORM', 'XML', '23', ''  WHERE 2306 NOT IN(SELECT id FROM game_api_interface WHERE id=2306);



INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23006', 'currency', 'user.currency', 't', NULL, NULL, NULL, 'RMB', '2301', NULL, 'OPUS-SPORT-货币类型', NULL, NULL   WHERE  23006  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23006);

INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23001', 'operator_id', 'operator_id', 't', NULL, NULL, NULL, NULL, '2301', NULL, 'OPUS-SPORT-operator_id', NULL, NULL   WHERE  23001  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23001);

INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23007', 'Language', 'user.locale', 't', NULL, NULL, NULL, 'zh-CN', '2301', NULL, 'OPUS-SPORT-语言类型', NULL, NULL   WHERE  23007  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23007);

INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23002', 'first_name', 'user.account', 't', NULL, NULL, NULL, NULL, '2301', NULL, 'OPUS-SPORT可与user_name一样', NULL, NULL   WHERE  23002  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23002);

INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23004', 'user_name', 'user.account', 't', NULL, NULL, NULL, NULL, '2301', NULL, 'OPUS-SPORT-用户名', NULL, NULL   WHERE  23004  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23004);

INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23005', 'odds_type', 'odds_type', 't', NULL, NULL, NULL, '32', '2301', NULL, 'OPUS-SPORT-盘类型', NULL, NULL   WHERE  23005  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23005);

INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23008', 'operator_id', 'operator_id', 't', NULL, NULL, '', '', '2302', '', 'OPUS-SPORT-operator_id', '', ''   WHERE  23008  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23008);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23009', 'user_name', 'user.account', 't', NULL, NULL, '', '', '2302', '', 'OPUS-SPORT-用户名', '', ''   WHERE  23009  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23009);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23010', 'operator_id', 'operator_id', 't', NULL, NULL, '', '', '2303', '', 'OPUS-SPORT-operator_id', '', ''   WHERE  23010  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23010);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23011', 'user_name', 'loginname', 't', NULL, NULL, '', '', '2303', '', 'OPUS-SPORT-用户名', '', ''   WHERE  23011  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23011);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23015', 'amount', 'amount', 't', NULL, NULL, '', '', '2304', '', 'OPUS-SPORT-金额', '', ''   WHERE  23015  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23015);

INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23012', 'operator_id', 'operator_id', 't', NULL, NULL, '', '', '2304', '', 'OPUS-SPORT-operator_id', '', ''   WHERE  23012  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23012);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23017', 'direction', 'direction', 't', NULL, NULL, NULL, '1', '2304', NULL, 'OPUS-SPORT-值固定为1表存款', NULL, NULL   WHERE  23017  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23017);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23013', 'user_name', 'user.account', 't', NULL, NULL, '', '', '2304', '', 'OPUS-SPORT-用户名', '', ''   WHERE  23013  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23013);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23014', 'trans_id', 'transId', 't', NULL, NULL, '', '', '2304', '', 'OPUS-SPORT-存款交易号', '', ''   WHERE  23014  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23014);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23016', 'currency', 'user.currency', 't', NULL, NULL, '', 'RMB', '2304', '', 'OPUS-SPORT-货币类型', '', ''   WHERE  23016  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23016);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23023', 'direction', 'direction', 't', NULL, NULL, '', '0', '2305', '', 'OPUS-SPORT-值固定为0表取款', '', ''   WHERE  23023  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23023);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23020', 'trans_id', 'transId', 't', NULL, NULL, '', '', '2305', '', 'OPUS-SPORT-存款交易号', '', ''   WHERE  23020  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23020);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23021', 'amount', 'amount', 't', NULL, NULL, '', '', '2305', '', 'OPUS-SPORT-金额', '', ''   WHERE  23021  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23021);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23022', 'currency', 'user.currency', 't', NULL, NULL, '', 'RMB', '2305', '', 'OPUS-SPORT-货币类型', '', ''   WHERE  23022  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23022);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23018', 'operator_id', 'operator_id', 't', NULL, NULL, '', '', '2305', '', 'OPUS-SPORT-operator_id', '', ''   WHERE  23018  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23018);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23019', 'user_name', 'user.account', 't', NULL, NULL, '', '', '2305', '', 'OPUS-SPORT-用户名', '', ''   WHERE  23019  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23019);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23025', 'user_name', 'user.account', 't', NULL, NULL, '', '', '2306', '', 'OPUS-SPORT-用户名', '', ''   WHERE  23025  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23025);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23024', 'operator_id', 'operator_id', 't', NULL, NULL, '', '', '2306', '', 'OPUS-SPORT-operator_id', '', ''   WHERE  23024  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23024);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23026', 'trans_id', 'transId', 't', NULL, NULL, '', '', '2306', '', 'OPUS-SPORT-存款交易号', '', ''   WHERE  23026  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23026);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23027', 'operator_id', 'operator_id', 't', NULL, NULL, '', '', '2307', '', 'OPUS-SPORT-operator_id', '', ''   WHERE  23027  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23027);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23029', 'date_start', 'date_start', 't', NULL, NULL, '', '', '2307', '', 'OPUS-SPORT-注单开始时间', '', ''   WHERE  23029  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23029);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23030', 'date_end', 'date_end', 't', NULL, NULL, '', '', '2307', '', 'OPUS-SPORT-注单结束时间', '', ''   WHERE  23030  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23030);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23032', 'lang', 'user.locale', 't', NULL, NULL, '', 'zh_CN', '2308', 'CN,HK,EN,TH,VN', 'OPUS-SPORT-游戏语言', '', ''   WHERE  23032  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23032);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23033', 'currency', 'user.currency', 't', NULL, NULL, '', 'RMB', '2308', '', 'OPUS-SPORT-货币类型', '', ''   WHERE  23033  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23033);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") SELECT  '23031', 'user_name', 'user.account', 't', NULL, NULL, '', '', '2308', '', 'OPUS-SPORT-用户名', '', ''   WHERE  23031  NOT IN(SELECT id FROM game_api_interface_request WHERE id=23031);






