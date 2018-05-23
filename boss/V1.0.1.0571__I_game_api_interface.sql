-- auto gen by steffan 2018-05-22 17:05:25  add by carl

--添加 OG-查询报表数据
INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
select  '7001', 'HTTP', 'getdata.aspx', 'report', 'GET', 'OG-查询报表数据，', 'org.soul.model.gameapi.param.ReportParam', 'org.soul.model.gameapi.result.ReportResult', 'FORM', 'XML', '7', ''
where 7001 not in (select id from game_api_interface where id = 7001);

--添加 OG-查询报表数据 参数
INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
select  '70011', 'agent', 'agent', 'f', NULL, NULL, '', NULL, '7001', '', 'OG-玩家所属代理', '', ''
where 70011 not in (select id from game_api_interface_request where id = 70011);

INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
select '70012', 'datestart', 'startTime', 'f', NULL, NULL, '',NULL, '7001', '', 'OG-开始时间', '', ''
where 70012 not in (select id from game_api_interface_request where id = 70012);

INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
select '70013', 'dateend', 'endTime', 'f', NULL, NULL, '', NULL, '7001', '', 'OG-结束时间', '', ''
where 70013 not in (select id from game_api_interface_request where id = 70013);

INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
select '70014', 'method', 'method', 'f', NULL, NULL, '', 'gr', '7001', '', 'OG-method', '', ''
where 70014 not in (select id from game_api_interface_request where id = 70014);

INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
select '70015', 'username', 'username', 'f', NULL, NULL, '', NULL, '7001', '', 'OG-玩家账号', '', ''
where 70015 not in (select id from game_api_interface_request where id = 70015);

INSERT INTO "game_api_interface_request" ("id", "api_field_name", "property_name", "required", "min_length", "max_length", "reg_exp", "default_value", "interface_id", "remarks", "comment", "min_value", "max_value")
select '70016', 'password', 'password', 'f', NULL, NULL, '', NULL, '7001', '', 'OG-玩家密码', '', ''
where 70016 not in (select id from game_api_interface_request where id = 70016);



--添加 API报表查询 按钮权限
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
select  '40302', 'API报表查询', 'report/gameTransaction/reportQueryData.html', 'API报表查询', '403', '', '2', 'boss', 'report:reportData', '2', '', 'f', 't', 't'
where 'report/gameTransaction/reportQueryData.html' not in (select url from sys_resource where url = 'report/gameTransaction/reportQueryData.html');

