-- auto gen by kobe 2016-09-21 21:01:51
INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
SELECT '280', 'HTTP', 'RegUserInfo', 'register', 'POST', 'SA-创建账户', 'org.soul.model.gameapi.param.RegisterParam', 'org.soul.model.gameapi.result.RegisterResult', 'FORM', 'XML', '17', ''
WHERE  NOT EXISTS(SELECT id FROM game_api_interface WHERE id=280);

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
SELECT '281', 'HTTP', 'LoginRequest', 'login', 'POST', 'SA-登录到游戏平台', 'org.soul.model.gameapi.param.LoginParam', 'org.soul.model.gameapi.result.LoginResult', 'FORM', 'XML', '17', ''
WHERE  NOT EXISTS(SELECT id FROM game_api_interface WHERE id=281);

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
SELECT '282', 'HTTP', 'KickUser', 'kickOut', 'POST', 'SA-强制登出', 'org.soul.model.gameapi.param.KickOutParam', 'org.soul.model.gameapi.result.KickOutResult', 'FORM', 'XML', '17', ''
WHERE  NOT EXISTS(SELECT id FROM game_api_interface WHERE id=282);

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
SELECT '283', 'HTTP', 'DebitBalanceDV', 'withdraw', 'POST', 'SA-从游戏平台取款', 'org.soul.model.gameapi.param.WithdrawParam', 'org.soul.model.gameapi.result.WithdrawResult', 'FORM', 'XML', '17', ''
WHERE  NOT EXISTS(SELECT id FROM game_api_interface WHERE id=283);

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
SELECT '284', 'HTTP', 'CreditBalanceDV', 'deposit', 'POST', 'SA-转账到游戏平台', 'org.soul.model.gameapi.param.DepositParam', 'org.soul.model.gameapi.result.DepositResult', 'FORM', 'XML', '17', ''
WHERE  NOT EXISTS(SELECT id FROM game_api_interface WHERE id=284);

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
SELECT '285', 'HTTP', 'GetUserStatusDV', 'fetchBalance', 'POST', 'SA-获取游戏平台即时余额', 'org.soul.model.gameapi.param.FetchBalanceParam', 'org.soul.model.gameapi.result.FetchBalanceResult', 'FORM', 'XML', '17', ''
WHERE  NOT EXISTS(SELECT id FROM game_api_interface WHERE id=285);

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
SELECT '286', 'HTTP', 'GetAllBetDetailsForTimeIntervalDV', 'fetchRecord', 'POST', 'SA-获取游戏平台注单', 'org.soul.model.gameapi.param.FetchRecordParam', 'org.soul.model.gameapi.result.FetchRecordResult', 'FORM', 'XML', '17', ''
WHERE  NOT EXISTS(SELECT id FROM game_api_interface WHERE id=286);

INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
SELECT '287', 'HTTP', 'CheckOrderId', 'checkTransfer', 'POST', 'SA-验证存取款交易号是否已经处理', 'org.soul.model.gameapi.param.CheckTransferParam', 'org.soul.model.gameapi.result.CheckTransferResult', 'FORM', 'XML', '17', ''
WHERE  NOT EXISTS(SELECT id FROM game_api_interface WHERE id=287);





