-- auto gen by admin 2017-01-02 16:09:59
INSERT INTO "game_api_provider" ("id", "abbr_name", "full_name", "api_url", "remarks", "jar_url", "api_class", "jar_version", "ext_json", "default_timezone", "support_agent")
SELECT '19', 'SB', '', 'http://api.ampinplayopt0matrix.com:8084/api/', '正式环境', 'file:/data/impl-jars/api/api-sb.jar', 'so.wwb.gamebox.service.gameapi.impl.SbGameApi', '201701010190137', '{"vendor_id":"OQDZ9GuwLbU","secret_key":"test_781QU5yLDmgrav3","operatorId":"Dawoo","gameUrl":"http://sbtest.test.ampinplayopt0matrix.com:8084/deposit_processlogin.aspx?lang={0}","loginUrl":"http://test.ampinplayopt0matrix.com/api/sb/login.html?key={0}","isDebug":"true","isFetchRecord":"true","SetMemberBetSetting":"false"}', '+0', 'f'
WHERE 19 NOT IN(SELECT id FROM game_api_provider WHERE id=19);


INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
SELECT '1901', 'HTTP', 'CreateMember', 'register', 'POST', 'SB-创建账号', 'org.soul.model.gameapi.param.RegisterParam', 'org.soul.model.gameapi.result.RegisterResult', 'FORM', 'JSON', '19', ''
WHERE 1901 NOT IN(SELECT id FROM game_api_interface WHERE id=1901);
INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
SELECT '1902', 'HTTP', 'KickUser', 'kickOut', 'POST', 'SB-踢出玩家', 'org.soul.model.gameapi.param.KickOutParam', 'org.soul.model.gameapi.result.KickOutResult', 'FORM', 'JSON', '19', ''
WHERE 1902 NOT IN(SELECT id FROM game_api_interface WHERE id=1902);
INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
SELECT '1903', 'HTTP', 'CheckUserBalance', 'fetchBalance', 'POST', 'SB-获取游戏平台即时余额', 'org.soul.model.gameapi.param.FetchBalanceParam', 'org.soul.model.gameapi.result.FetchBalanceResult', 'FORM', 'JSON', '19', ''
WHERE 1903 NOT IN(SELECT id FROM game_api_interface WHERE id=1903);
INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
SELECT '1904', 'HTTP', 'FundTransfer', 'deposit', 'POST', 'SB-玩家充值', 'org.soul.model.gameapi.param.DepositParam', 'org.soul.model.gameapi.result.DepositResult', 'FORM', 'JSON', '19', ''
WHERE 1904 NOT IN(SELECT id FROM game_api_interface WHERE id=1904);
INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
SELECT '1905', 'HTTP', 'FundTransfer', 'withdraw', 'POST', 'SB-从游戏平台取款-', 'org.soul.model.gameapi.param.WithdrawParam', 'org.soul.model.gameapi.result.WithdrawResult', 'FORM', 'JSON', '19', ''
WHERE 1905 NOT IN(SELECT id FROM game_api_interface WHERE id=1905);
INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
SELECT '1906', 'HTTP', 'CheckFundTransfer', 'checkTransfer', 'POST', 'SB-检查转账是否成功', 'org.soul.model.gameapi.param.CheckTransferParam', 'org.soul.model.gameapi.result.CheckTransferResult', 'FORM', 'JSON', '19', ''
WHERE 1906 NOT IN(SELECT id FROM game_api_interface WHERE id=1906);
INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
SELECT '1907', 'HTTP', 'GetBetDetail', 'fetchRecord', 'POST', 'SB-获取注单', 'org.soul.model.gameapi.param.FetchRecordParam', 'org.soul.model.gameapi.result.FetchRecordResult', 'FORM', 'JSON', '19', ''
WHERE 1907 NOT IN(SELECT id FROM game_api_interface WHERE id=1907);
INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
SELECT '1908', 'HTTP', 'SetMemberBetSetting', 'login', 'POST', 'SB-玩家登陆', 'org.soul.model.gameapi.param.LoginParam', 'org.soul.model.gameapi.result.LoginResult', 'FORM', 'JSON', '19', ''
WHERE 1908 NOT IN(SELECT id FROM game_api_interface WHERE id=1908);


INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '19001', 'bet_setting', 'bet_setting', 'f', NULL, NULL, '', '[{"sport_type": "1","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000},{"sport_type": "2","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000},{"sport_type": "3","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000},{"sport_type": "5","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000},{"sport_type": "8","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000},{"sport_type": "10","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000},{"sport_type": "11","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000},{"sport_type": "19","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000},{"sport_type": "99MP","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000},{"sport_type": "151","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000},{"sport_type": "161","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000,"max_bet_per_ball":200000},{"sport_type": "180","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000}]', '1901', '', '下注限制选项', '', ''
 WHERE 19001 NOT IN(SELECT id FROM game_api_interface_request WHERE id=19001);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1909', 'maxtransfer', 'maxtransfer', 't', NULL, NULL, '', '100000', '1901', '', 'SB-最大限制轉帳金額', '', ''
WHERE 1909 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1909);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1908', 'mintransfer', 'mintransfer', 't', NULL, NULL, '', '1', '1901', '', 'SB-最小限制轉帳金額', '', ''
WHERE 1908 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1908);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1907', 'currency', 'currency', 't', NULL, NULL, '', 'UUS', '1901', '', 'SB-為此會員設置幣別', '', ''
WHERE 1907 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1907);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1906', 'oddstype', 'oddstype', 't', NULL, NULL, '', '1', '1901', '', 'SB-為此會員設置賠率類型', '', ''
WHERE 1906 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1906);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1905', 'username', 'user.account', 't', NULL, NULL, '', '', '1901', '', 'SB-會員登入名稱', '', ''
WHERE 1905 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1905);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1904', 'lastname', 'user.account', 't', NULL, NULL, '', '', '1901', '', 'SB-會員名字', '', ''
WHERE 1904 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1904);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1903', 'firstname', 'user.account', 't', NULL, NULL, '', '', '1901', '', 'SB-會員姓氏', '', ''
WHERE 1903 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1903);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1902', 'operatorId', 'operatorId', 't', NULL, NULL, '', '', '1901', '', 'SB-此 ID 為廠商自行定義', '', ''
WHERE 1902 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1902);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1901', 'vendor_member_id', 'user.account', 't', NULL, NULL, '', '', '1901', '', 'SB-厂商会员识别码', '', ''
WHERE 1901 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1901);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1900', 'vendor_id', 'vendor_id', 't', NULL, NULL, '', NULL, '1901', NULL, 'SB-厂商ID', NULL, NULL
 WHERE 1900 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1900);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1911', 'vendor_member_id', 'user.account', 't', NULL, NULL, '^[0-9a-zA-Z]{1,20}$', '', '1902', '', 'SB-厂商会员识别码', '', ''
WHERE 1911 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1911);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1910', 'vendor_id', 'vendor_id', 't', NULL, NULL, '', '', '1902', '', 'SB-厂商ID', '', ''
WHERE 1910 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1910);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1932', 'wallet_id', 'wallet_id', 't', NULL, NULL, '^[0-9a-zA-Z]{1,20}$', '1', '1903', '', 'SB-錢包識別碼,1:sportbook,5:AG,6:GD', '', ''
WHERE 1932 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1932);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1931', 'vendor_member_ids', 'vendor_member_ids', 't', NULL, NULL, '', '', '1903', '', 'SB-厂商会员识别码((以“,”作分隔))', '', ''
WHERE 1931 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1931);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1930', 'vendor_id', 'vendor_id', 't', NULL, NULL, '', '', '1903', '', 'SB-厂商ID', '', ''
WHERE 1930 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1930);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1946', 'wallet_id', 'wallet_id', 't', NULL, NULL, '', '1', '1904', '', 'SB-錢包識別碼,1:sportbook,5:AG,6:GD', '', ''
WHERE 1946 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1946);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1945', 'direction', 'direction', 't', NULL, NULL, '', '1', '1904', '', 'SB-資金轉帳方向 0:取款  1:存款', '', ''
WHERE 1945 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1945);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1944', 'currency', 'user.currency', 't', NULL, NULL, '', '', '1904', '', 'SB-币种', '', ''
WHERE 1944 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1944);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1943', 'amount', 'amount', 't', NULL, NULL, '', '', '1904', '', 'SB-轉帳總金額', '', ''
WHERE 1943 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1943);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1942', 'vendor_trans_id', 'transId', 't', NULL, NULL, '', '', '1904', '', 'SB-订单号', '', ''
WHERE 1942 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1942);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1941', 'vendor_member_id', 'user.account', 't', NULL, NULL, '^[0-9a-zA-Z]{1,20}$', '', '1904', '', 'SB-厂商会员识别码', '', ''
WHERE 1941 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1941);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1940', 'vendor_id', 'vendor_id', 't', NULL, NULL, '', '', '1904', '', 'SB-厂商ID', '', ''
WHERE 1940 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1940);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1956', 'wallet_id', 'wallet_id', 't', NULL, NULL, '', '1', '1905', '', 'SB-錢包識別碼,1:sportbook,5:AG,6:GD', '', ''
WHERE 1956 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1956);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1955', 'direction', 'direction', 't', NULL, NULL, '', '0', '1905', '', 'SB-資金轉帳方向 0:取款  1:存款', '', ''
WHERE 1955 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1955);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1954', 'currency', 'user.currency', 't', NULL, NULL, '', '', '1905', '', 'SB-币种', '', ''
WHERE 1954 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1954);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1953', 'amount', 'amount', 't', NULL, NULL, '', '', '1905', '', 'SB-轉帳總金額', '', ''
WHERE 1953 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1953);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1952', 'vendor_trans_id', 'transId', 't', NULL, NULL, '', '', '1905', '', 'SB-订单号', '', ''
WHERE 1952 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1952);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1951', 'vendor_member_id', 'user.account', 't', NULL, NULL, '^[0-9a-zA-Z]{1,20}$', '', '1905', '', 'SB-厂商会员识别码', '', ''
WHERE 1951 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1951);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1950', 'vendor_id', 'vendor_id', 't', NULL, NULL, '', '', '1905', '', 'SB-厂商ID', '', ''
WHERE 1950 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1950);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1966', 'wallet_id', 'wallet_id', 't', NULL, NULL, '', '1', '1906', '', 'SB-錢包識別碼,1:sportbook,5:AG,6:GD', '', ''
WHERE 1966 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1966);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1962', 'vendor_trans_id', 'transId', 't', NULL, NULL, '', '', '1906', '', 'SB-订单号', '', ''
WHERE 1962 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1962);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1960', 'vendor_id', 'vendor_id', 't', NULL, NULL, '', '', '1906', '', 'SB-厂商ID', '', ''
WHERE 1960 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1960);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1972', 'options', 'options', 'f', NULL, NULL, '', '', '1907', '', '隊伍 version key 或聯盟 version key 或兩者都要', '', ''
WHERE 1972 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1972);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1971', 'version_key', 'startId', 't', NULL, NULL, '', '', '1907', '', 'SB-版本號', '', ''
WHERE 1971 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1971);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1970', 'vendor_id', 'vendor_id', 't', NULL, NULL, '', '', '1907', '', 'SB-厂商ID', '', ''
WHERE 1970 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1970);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1982', 'bet_setting', 'bet_setting', 'f', NULL, NULL, '', '[{"sport_type": "1","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000},{"sport_type": "2","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000},{"sport_type": "3","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000},{"sport_type": "5","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000},{"sport_type": "8","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000},{"sport_type": "10","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000},{"sport_type": "11","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000},{"sport_type": "19","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000},{"sport_type": "99MP","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000},{"sport_type": "151","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000},{"sport_type": "161","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000,"max_bet_per_ball":200000},{"sport_type": "180","min_bet": 10,"max_bet": 200000,"max_bet_per_match": 200000}]', '1908', '', '下注限制选项', '', ''
WHERE 1982 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1982);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1981', 'vendor_member_id', 'user.account', 't', NULL, NULL, '', '', '1908', '', 'SB-廠商會員識別碼', '', ''
WHERE 1981 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1981);

 INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '1980', 'vendor_id', 'vendor_id', 't', NULL, NULL, '', '', '1908', '', 'SB-厂商ID', '', ''
WHERE 1980 NOT IN(SELECT id FROM game_api_interface_request WHERE id=1980);


