-- auto gen by alvin 2016-06-16 13:16:51
update game_api_provider set jar_version=to_char(CURRENT_TIMESTAMP, 'yyyymmddhhmmss');
-- launch-mode: mock,api
update game_api_provider set ext_json='{"username":"DawooCNY","password":"Password123","defaultApiUser":"apiadmin","defaultApiPassword":"apipassword","currencyCode":"CNY","SH_NET_ID":"81119847","horid":"81119836","ipaddress":"202.181.174.37","parentID":"Dawoo","launch-mode":"api","search-setting":{"check-max-time":120,"ahead-minute":15,"backward-minute":10,"auto-settled":true,"settled-after-bet-minute":10,"sleep-time":5000},"API_URL":"/lps/j_spring_security_check","headers":{"X-Requested-With":"X-Api-Client","X-Api-Call":"X-Api-Client"},"additional":{"currencyFormat":"%23%2C%23%23%23.%23%23"}}'  where id=3;
--26.参数{0},为HOR值,如:80000483
update game_api_interface set api_action='/lps/secure/hortx/{0}' where provider_id=3 and id=26;
--26.参数{0},为SH值,如:80000495
update game_api_interface set api_action='/lps/secure/network/{0}/downline' where provider_id=3 and id=21;