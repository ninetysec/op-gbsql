-- auto gen by Alvin 2016-05-13 12:54:21
--更新所有版本号
update game_api_provider set jar_version=to_char(CURRENT_TIMESTAMP, 'yyyymmddhhmmss');
--MG--真实环境
update game_api_provider set ext_json='{"username":"DawooCNY","password":"Password123","defaultApiUser":"apiadmin","defaultApiPassword":"apipassword","currencyCode":"CNY","SH_NET_ID":"81119847","horid":"81119836","ipaddress":"202.181.174.37","parentID":"Dawoo","launch-mode":"api","search-setting":{"check-max-time":120,"ahead-minute":25,"backward-minute":15,"auto-settled":true,"settled-after-bet-minute":10,"sleep-time":5000},"API_URL":"/lps/j_spring_security_check","headers":{"X-Requested-With":"X-Api-Client","X-Api-Call":"X-Api-Client"},"additional":{"currencyFormat":"%23%2C%23%23%23.%23%23"},"links":{"live":"https://etiloader3.valueactive.eu/ETILoader/default.aspx?token=%s&casinoid=%s&UL=%s&VideoQuality=3&ModuleID=70004&ClientID=4&ClientType=1&UserType=0&ProductID=2&BetProfileID=0&ActiveCurrency=Credits&LoginName=&Password=&StartingTab=Baccarat&CustomLDParam=MultiTableMode^^1","ele":"https://launch88.gameassists.co.uk/aurora/?theme=158poker&ul=%s&variant=vanguard&AuthToken=%s&gameid=%s","html5":"http://mobile3.gameassists.co.uk/MobileWebServices/casino/game/launch/mobile88/%s/%s?casinoID=2487&lobbyURL=%s&bankingURL=%s&loginType=VanguardSessionToken&authToken=%s&isRGI=true&currencyFormat=%s"}}'  where id=3;

INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('940', 'amount', 'amount', 't', NULL, NULL, NULL, NULL, '27', NULL, 'MG-CHECK-转账金额', NULL, NULL);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('941', 'product', 'product', 't', NULL, NULL, NULL, 'casino', '27', NULL, 'MG-CHECK-产品类型', NULL, NULL);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('942', 'currencyCode', 'user.currency', 't', NULL, NULL, '^[a-zA-Z]{3}$', NULL, '27', NULL, 'MG-CHECK-充值币别', NULL, NULL);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value") VALUES ('943', 'operation', 'type', 't', NULL, NULL, '^[a-z]{5,8}$', '', '27', 'topup,withdraw', 'MG-CHECK-充值类型', NULL, NULL);