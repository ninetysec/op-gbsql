-- auto gen by admin 2017-01-20 09:42:40
INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
SELECT '1909', 'HTTP', 'GetGameDetail', 'extend', 'POST', 'SB-為取得賽事詳細資料', 'org.soul.model.gameapi.param.ExtendParam', 'org.soul.model.gameapi.result.ExtendResult', 'FORM', 'JSON', '19', ''
WHERE 1909 NOT IN(SELECT id FROM game_api_interface WHERE id=1909);


INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 SELECT '19002', 'vendor_id', 'vendor_id', 't', NULL, NULL, NULL, '', '1909', '', 'SB-厂商ID', '', ''
 WHERE 19002 NOT IN(SELECT id FROM game_api_interface_request WHERE id=19002);

INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
SELECT '19003', 'match_ids', 'match_ids', 't', NULL, NULL, NULL, '', '1909', '', '赛事ID集合', '', ''
WHERE 19003 NOT IN(SELECT id FROM game_api_interface_request WHERE id=19003);

UPDATE game_api_provider SET  ext_json='{"vendor_id":"OQDZ9GuwLbU","secret_key":"live_e4sBgsmTHHkNAbd","operatorId":"Dawoo","domain":".ampinplayopt0matrix.com","gameUrl":"http://mkt.ampinplayopt0matrix.com:8084/deposit_processlogin.aspx","mobileUrl":"http://ismart.ampinplayopt0matrix.com/deposit_processlogin.aspx","wabUrl":"iwap.ampinplayopt0matrix.com:8084/deposit_processlogin.aspx","loginUrl":"http://ampinplayopt0matrix.com/api/sb/login.html?key={0}","isFetchRecord":"true","SetMemberBetSetting":"false","validateTokenExpire":60}' WHERE id=19;
