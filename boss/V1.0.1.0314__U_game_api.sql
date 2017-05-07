-- auto gen by admin 2017-03-21 13:50:13
UPDATE game_api_provider set ext_json='{"private-key":"Y88hjdjhe7hHYHuhu7ejhrYYK","public-key":"YYQheduryey734u347rywehuhreuhterureu","runner":"php","encode":"encrypt.php","code":"yaa","gate-code":"YYGSTE887E","company-code":"A0036","launch-mode":"api","log-level":1,"fetch-type":"1","check-search-type":"1","split":"|","end":"=@=","batch-size":5000,"GMT":"GMT-04:00","record-date-format":"\\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}","login-url":"http://hyxu36.uv178.com/whb/direct-login.php?activekey={0}&acc={1}&langs={2}","mobile-url":"http://hyxu36.uv178.com/mobile/direct-login.php?activekey={0}&acc={1}&langs={2}","search-minute":"60"}' where id=12;


INSERT INTO game_api_interface ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
 select '236', 'HTTP', 'get-transaction-data.php?r=', 'fetchModifiedRecord', 'GET', 'SS-游戏注单记录', 'org.soul.model.gameapi.param.FetchModifiedRecordParam', 'org.soul.model.gameapi.result.FetchModifiedRecordResult', 'FORM', 'XML', '12', '{"encrypt-mode":3,"url-mode":1,"action-code":"GET_TRANSACTION_DATA","data-format":"action-code:2,split:1,gate-code:1,split:1,fetch-type:1,split:1,searchTime:3,split:1,account:3,split:1,account:3,end:1"}'
 where 236 NOT  in (SELECT id FROM game_api_interface WHERE id=236);


INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
select '1140', 'searchTime', 'searchTime', 't', NULL, NULL, '', '', '236', '', '查询时间', '', ''
 where 1140 NOT  in (SELECT id FROM game_api_interface_request WHERE id=1140);

INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
 select '1141', 'account', 'account', 'f', NULL, NULL, '', '', '236', '', '查询玩家', '', ''
 where 1141 NOT  in (SELECT id FROM game_api_interface_request WHERE id=1141);