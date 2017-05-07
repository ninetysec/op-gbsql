-- auto gen by Alvin 2016-06-25 05:47:49
update game_api_provider set jar_version=to_char(CURRENT_TIMESTAMP, 'yyyymmddhhmmss');
-- launch-mode: mock,api
-- 增加token有效期以及是否开启详细日志.
update game_api_provider set ext_json='{"username":"DawooCNY","password":"Password123","defaultApiUser":"apiadmin","defaultApiPassword":"apipassword","currencyCode":"CNY","SH_NET_ID":"81119847","horid":"81119836","ipaddress":"202.181.174.37","parentID":"Dawoo","launch-mode":"api","token-expired":5400,"log-level":1,"search-setting":{"check-max-time":120,"ahead-minute":15,"backward-minute":10,"auto-settled":true,"settled-after-bet-minute":10,"sleep-time":5000},"API_URL":"/lps/j_spring_security_check","headers":{"X-Requested-With":"X-Api-Client","X-Api-Call":"X-Api-Client"},"additional":{"currencyFormat":"%23%2C%23%23%23.%23%23"}}'  where id=3;
