-- auto gen by george 2017-11-20 09:46:04
INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
 SELECT '169', 'HTTP', 'report/getplayergames/startdate/{0}/enddate/{1}/membercode/{2}/producttype/{3}', 'extend', 'GET', 'PT-获取游戏平台游戏详情链接', 'org.soul.model.gameapi.param.ExtendParam', 'org.soul.model.gameapi.result.ExtendResult', 'JSON', 'JSON', '6', '' WHERE  169 NOT IN(SELECT ID FROM  game_api_interface WHERE ID=169);


INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value",
"max_value") SELECT'16901', 'producttype', 'producttype', 't', NULL, NULL, '', '0', '169', '', 'PT-产品类型', '', ''WHERE   16901  NOT IN (SELECT ID FROM game_api_interface_request  WHERE ID= 16901);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value",
"max_value") SELECT'16904', 'merchantname', 'merchantname', 't', NULL, NULL, '', '', '169', '', 'PT-代理名称', '', ''WHERE   16904  NOT IN (SELECT ID FROM game_api_interface_request  WHERE ID= 16904);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value",
"max_value") SELECT'16905', 'merchantcode', 'merchantcode', 't', NULL, NULL, '', '', '169', '', 'PT-代理code', '', ''WHERE   16905  NOT IN (SELECT ID FROM game_api_interface_request  WHERE ID= 16905);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value",
"max_value") SELECT'16902', 'enddate', 'enddate', 't', NULL, NULL, '', '', '169', '', 'PT-查询结束时间', '', ''WHERE   16902  NOT IN (SELECT ID FROM game_api_interface_request  WHERE ID= 16902);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value",
"max_value") SELECT'16903', 'startdate', 'startdate', 't', NULL, NULL, '', '', '169', '', 'PT-查询开始时间', '', ''WHERE   16903  NOT IN (SELECT ID FROM game_api_interface_request  WHERE ID= 16903);
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value",
"max_value") SELECT'16906', 'membercode', 'membercode', 't', NULL, NULL, '', '', '169', '', 'PT-玩家游戏账号', '', ''WHERE  16906   NOT IN (SELECT ID FROM game_api_interface_request  WHERE ID= 16906);