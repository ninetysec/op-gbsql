-- auto gen by admin 2016-12-24 10:40:02
INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
SELECT '159', 'HTTP', 'getdata.aspx', 'extend', 'POST', 'OG-游戏结果数据', 'org.soul.model.gameapi.param.ExtendParam', 'org.soul.model.gameapi.result.ExtendResult', 'FORM', 'XML', '7', '' where '159' not in (select id from game_api_interface where id='159');

INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
SELECT '480', 'agent', 'agent', 't', NULL, NULL, '', '', '159', '', 'OG-代理', '', '' where '480' not in (select id from game_api_interface_request where id='480');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
SELECT '481', 'vendorid', 'vendorid', 't', NULL, NULL, '', '', '159', '', 'OG-起始序号，每批最多200', '', ''where '481' not in (select id from game_api_interface_request where id='481');
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
SELECT '482', 'method', 'method', 't', NULL, NULL, '', 'ggr', '159', '', 'OG-方法', '', ''where '482' not in (select id from game_api_interface_request where id='482');


INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
SELECT '202', 'HTTP', '', 'extend', 'POST', 'AG-游戏结果', 'org.soul.model.gameapi.param.ExtendParam', 'org.soul.model.gameapi.result.ExtendResult', 'XML', 'XML', '9', ''
where '202' not in (select id from game_api_interface where id='202');

INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
SELECT '837', 'startTime', 'startTime', 't', NULL, NULL, '', '', '202', '', 'AG-查询开始时间', '', ''where '837' not in (select id from game_api_interface_request where id='837');
