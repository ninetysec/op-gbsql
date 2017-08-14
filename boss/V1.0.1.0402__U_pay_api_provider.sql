-- auto gen by cherry 2017-08-14 15:07:08
UPDATE game_api_provider SET  ext_json='{"BrandId":"d2db4aea-3b69-e611-80c4-000d3a805b30","APIKey":"458F1154-B678-4BF9-AD47-99BEFA92313F","loginurl":"https://app-a.insvr.com/play?brandid={0}&brandgameid={1}&token={2}&mode={3}&locale={4}&lobbyurl={5}","trialUrl":"https://app-a.insvr.com/play?brandid={0}&brandgameid={1}&mode={2}&locale={3}&lobbyurl={4}","search-minute":"5","xmlns":"http://ws.oxypite.com/","supportReSend":"true"}' WHERE id=15;

UPDATE game_api_provider SET  ext_json='{"isFetchRecord":"true","currency_agent_conf":{"CNY":{"parent_id":"320157","api_username":"Dawoo2CNY_api","api_password":"65pj5nTFRUMTQGELIKgNGbKO","auth_username":"Dawoo2CNY_auth","auth_password":"u$+nzGxz7%VcWgKlFSaZBA+d","currency":"CNY","language":"zh"},"JPY":{"parent_id":"1031315","api_username":"Dawoo2JPY_api","api_password":"G3LGIvCWJPKGVkHBNSmNDzh0","auth_username":"Dawoo2JPY_auth","auth_password":"1wS&jCdNlKyRJTL9EWY0uEzZ","currency":"JPY","language":"jp_JP"}},,"DEMO":{"parent_id":"448365","api_username":"DawooZAR","api_password":"SxAqclCm2FousCmn8x7B","auth_username":"dawoo_auth","auth_password":"1wS&SxAqclCm2FousCmn8x7B","currency":"CNY","language":"zh"}},"tx_id":"TEXT-TX-ID","balance_type":"CREDIT_BALANCE","timezone":"UTC","validateTokenExpire":1000000,"search-minute":"10","continue-search":true,"isDebug":true,"auth_url":"http://3rd.game.api.com/newmg-auth-api/oauth/token","search-setting":{"check-max-time":120,"ahead-minute":3,"backward-minute":5,"auto-settled":true,"settled-after-bet-minute":2,"sleep-time":5000}}' WHERE id=3;


UPDATE game_api_provider SET ext_json = '{"bankId":"2231","pass_key":"ouoN2W4w6Kjf","loginUrl":"https://hongtubet-gp3.betsoftgaming.com/ctenter.do?bankId={0}&gameId={1}&mode={2}&lang={3}&balance={4}&token={5}","search-minute":"5","isFetchRecord":"true","trialUrl":"https://hongtubet-gp3.betsoftgaming.com/guestmode.do?bankId={0}&gameId={1}&lang={2}"}' WHERE id = 20;


UPDATE game_api_provider SET ext_json = '{"merchantname":"dawooprod","merchantcode":"QXk2MRtViePbJQSS8YCg781QU5yLDmgr","loginurl":"http://ampinplayopt0matrix.com/api/pt/login.html?key={0}","setNum":"500","search-minute":"1","pre_minute":"0","pre_modify_minute":"1","supportReSend":"true","trialUrl":"http://cache.download.banner.longsnake88.com/flash/74/launchcasino.html?mode=offline&affiliates=1&language={0}&game={1}"}' WHERE id = 6;

UPDATE game_api_provider SET  ext_json='{"agent":"og037dai","UserKey":"a3jkm5w2za78","loginurl":"http://cashapi.n80tu2.com/cashapi/DoBusiness.aspx","setNum":"300","recordurl":"http://3rd.game.api.com/og-record-api/cashapi/getdata.aspx","supportReSend":"false","trialUrl":"http://www.og6666.com/freeplay/"}' WHERE id=7;

UPDATE game_api_provider SET  ext_json='{"website":"dawoo","currency_agent_conf":{"CNY":{"uppername":"ddwb001"},"JPY":{"uppername":"ddawoojpy"}},"gameUrl":"http://3rd.game.api.com/bb-login-api/app/WebService/JSON/display.php","loginUrl":"https://888.ampinplayopt0matrix.com/app/WebService/JSON/display.php","setNum":"500","search-minute":"5","modify-minute":"5","isFetchRecord":"true","supportReSend":"true"}' WHERE id=10;


select redo_sqls($$
  ALTER table game_api_provider add column trial bool;
$$);
COMMENT ON COLUMN "game_api_provider"."trial" IS '是否支持试玩';

UPDATE game_api_provider SET trial='false';
UPDATE game_api_provider SET trial='true' WHERE id in('3','6','7','9','15','16','17','20','25','26','27','28');