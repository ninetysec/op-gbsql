-- auto gen by linsen 2018-08-27 11:09:41
-- 乐游棋牌 by snow

-- 9.task_schedule
INSERT INTO task_schedule (job_name, alias_name, job_group, job_class, job_method, is_local, status, cronexpression, is_sync, description, create_time, update_time, job_code, is_system, is_dynamic, job_method_arg, job_method_arg_class, belong_to_idc, scheduler)
  SELECT 'apiId-46-leg-对单记录', NULL, NULL, 'so.wwb.gamebox.service.company.PlayerGameOrderAdditionJob', 'execute', 'true', 1, '0 0/5 * * * ?', 'true', 'leg对单任务', now(), NULL, 'api-46-CHECKUP_NORMAL', 'false', 'false', 46, 'java.lang.Integer', 'A', 'scheduler4Api'
  WHERE not exists (SELECT id FROM task_schedule where job_code = 'api-46-CHECKUP_NORMAL' and job_method_arg='46');

--10.game_api_provider
INSERT INTO game_api_provider (id, abbr_name, full_name, api_url, remarks, jar_url, api_class, jar_version, ext_json, default_timezone, support_agent, trial, proxy, is_resend, resend_intervals,  api_origin_url)
select 46, 'LEG', '乐游棋牌', 'http://3rd.game.api.com/leg-api', '接口地址：https://legapi.ledingnet.com:189/channelHandle；拉单独立接口：https://legrec.ledingnet.com:190/getRecordHandle', 'file:/data/impl-jars/api/api-leg.jar', 'so.wwb.gamebox.service.gameapi.impl.LegGameApi', 20180823050829, '{"apiurl":{"fetchRecord":"http://3rd.game.api.com/leg-record-api/getRecordHandle","others":"http://3rd.game.api.com/leg-api/channelHandle"},"agent":"70043","deskey":"7b00d5750d7c46c0","md5key":"d626631cc37f423a","search-minute":"5","operateType":{"login":"0","fetchBalance":"7","deposit":"2","withdraw":"3","fetchRecord":"6","register":"0"}}', +8, 'false', 'false', 'false', 'true', 12,  ''
where not exists(select id from game_api_provider where id=46);

--11.game_api_interface
INSERT INTO game_api_interface (id, protocol, api_action, local_action, http_method, remarks, param_class, result_class, request_content_type, response_content_type, provider_id, ext_json)
  SELECT 4601, 'HTTPS', NULL, 'login', 'GET', 'LEG-登录', 'org.soul.model.gameapi.param.LoginParam', 'org.soul.model.gameapi.result.LoginResult', 'JSON', 'JSON', 46, NULL
  WHERE NOT EXISTS(select id from game_api_interface where id=4601 and provider_id=46);

INSERT INTO game_api_interface (id, protocol, api_action, local_action, http_method, remarks, param_class, result_class, request_content_type, response_content_type, provider_id, ext_json)
  SELECT 4602, 'HTTPS', NULL, 'fetchBalance', 'GET', 'LEG-获取余额', 'org.soul.model.gameapi.param.FetchBalanceParam', 'org.soul.model.gameapi.result.FetchBalanceResult', 'JSON', 'JSON', 46, NULL
WHERE NOT EXISTS(select id from game_api_interface where id=4602 and provider_id=46);

INSERT INTO game_api_interface (id, protocol, api_action, local_action, http_method, remarks, param_class, result_class, request_content_type, response_content_type, provider_id, ext_json)
  SELECT 4603, 'HTTPS', NULL, 'deposit', 'GET', 'LEG-上分', 'org.soul.model.gameapi.param.DepositParam', 'org.soul.model.gameapi.result.DepositResult', 'JSON', 'JSON', 46, NULL
WHERE NOT EXISTS(select id from game_api_interface where id=4603 and provider_id=46);

INSERT INTO game_api_interface (id, protocol, api_action, local_action, http_method, remarks, param_class, result_class, request_content_type, response_content_type, provider_id, ext_json)
  SELECT 4604, 'HTTPS', NULL, 'withdraw', 'GET', 'LEG-下分', 'org.soul.model.gameapi.param.WithdrawParam', 'org.soul.model.gameapi.result.WithdrawResult', 'JSON', 'JSON', 46, NULL
WHERE NOT EXISTS(select id from game_api_interface where id=4604 and provider_id=46);

INSERT INTO game_api_interface (id, protocol, api_action, local_action, http_method, remarks, param_class, result_class, request_content_type, response_content_type, provider_id, ext_json)
SELECT 4605, 'HTTPS', NULL, 'fetchRecord', 'GET', 'LEG-查询注单', 'org.soul.model.gameapi.param.FetchRecordParam', 'org.soul.model.gameapi.result.FetchRecordResult', 'JSON', 'JSON', 46, NULL
WHERE NOT EXISTS(select id from game_api_interface where id=4605 and provider_id=46);

INSERT INTO game_api_interface (id, protocol, api_action, local_action, http_method, remarks, param_class, result_class, request_content_type, response_content_type, provider_id, ext_json)
  SELECT 4606, 'HTTPS', NULL, 'register', 'GET', 'LEG-注册', 'org.soul.model.gameapi.param.RegisterParam', 'org.soul.model.gameapi.result.RegisterResult', 'JSON', 'JSON', 46, NULL
  WHERE NOT EXISTS(select id from game_api_interface where id=4606 and provider_id=46);

--12.api_provider_interface_request;
-- login
INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46011, 'agent', 'agent', 'true', NULL, NULL, NULL, NULL, 4601, 'LEG-代理编号', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46011 and interface_id=4601);

INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46012, 'timestamp', 'timestamp', 'true', NULL, NULL, NULL, NULL, 4601, 'LEG-当前时间戳', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46012 and interface_id=4601);

INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46013, 'param', 'param', 'true', NULL, NULL, NULL, NULL, 4601, 'LEG-操作类型、玩家账号、金额、流水号、玩家ip、站点标识符、游戏id', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46013 and interface_id=4601);

INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46014, 'key', 'key', 'true', NULL, NULL, NULL, NULL, 4601, 'LEG-agent+timestamp+MD5Key', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46014 and interface_id=4601);

-- fetchBalance
INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46021, 'agent', 'agent', 'true', NULL, NULL, NULL, NULL, 4602, 'LEG-代理编号', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46021 and interface_id=4602);

INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46022, 'timestamp', 'timestamp', 'true', NULL, NULL, NULL, NULL, 4602, 'LEG-当前时间戳', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46022 and interface_id=4602);

INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46023, 'param', 'param', 'true', NULL, NULL, NULL, NULL, 4602, 'LEG-操作类型、玩家账号、金额、流水号、玩家ip、站点标识符、游戏id', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46023 and interface_id=4602);

INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46024, 'key', 'key', 'true', NULL, NULL, NULL, NULL, 4602, 'LEG-agent+timestamp+MD5Key', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46024 and interface_id=4602);

-- deposit
INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46031, 'agent', 'agent', 'true', NULL, NULL, NULL, NULL, 4603, 'LEG-代理编号', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46031 and interface_id=4603);

INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46032, 'timestamp', 'timestamp', 'true', NULL, NULL, NULL, NULL, 4603, 'LEG-当前时间戳', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46032 and interface_id=4603);

INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46033, 'param', 'param', 'true', NULL, NULL, NULL, NULL, 4603, 'LEG-操作类型、玩家账号、金额、流水号、玩家ip、站点标识符、游戏id', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46033 and interface_id=4603);

INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46034, 'key', 'key', 'true', NULL, NULL, NULL, NULL, 4603, 'LEG-agent+timestamp+MD5Key', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46034 and interface_id=4603);

--withdraw
INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46041, 'agent', 'agent', 'true', NULL, NULL, NULL, NULL, 4604, 'LEG-代理编号', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46041 and interface_id=4604);

INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46042, 'timestamp', 'timestamp', 'true', NULL, NULL, NULL, NULL, 4604, 'LEG-当前时间戳', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46042 and interface_id=4604);

INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46043, 'param', 'param', 'true', NULL, NULL, NULL, NULL, 4604, 'LEG-操作类型、玩家账号、金额、流水号、玩家ip、站点标识符、游戏id', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46043 and interface_id=4604);

INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46044, 'key', 'key', 'true', NULL, NULL, NULL, NULL, 4604, 'LEG-agent+timestamp+MD5Key', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46044 and interface_id=4604);

-- fetchRecord
INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46051, 'agent', 'agent', 'true', NULL, NULL, NULL, NULL, 4605, 'LEG-代理编号', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46051 and interface_id=4605);

INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46052, 'timestamp', 'timestamp', 'true', NULL, NULL, NULL, NULL, 4605, 'LEG-当前时间戳', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46052 and interface_id=4605);

INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46053, 'param', 'param', 'true', NULL, NULL, NULL, NULL, 4605, 'LEG-操作类型、玩家账号、金额、流水号、玩家ip、站点标识符、游戏id', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46053 and interface_id=4605);

INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46054, 'key', 'key', 'true', NULL, NULL, NULL, NULL, 4605, 'LEG-agent+timestamp+MD5Key', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46054 and interface_id=4605);


-- register
INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46061, 'agent', 'agent', 'true', NULL, NULL, NULL, NULL, 4606, 'LEG-代理编号', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46061 and interface_id=4606);

INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46062, 'timestamp', 'timestamp', 'true', NULL, NULL, NULL, NULL, 4606, 'LEG-当前时间戳', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46062 and interface_id=4606);

INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46063, 'param', 'param', 'true', NULL, NULL, NULL, NULL, 4606, 'LEG-操作类型、玩家账号、金额、流水号、玩家ip、站点标识符、游戏id', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46063 and interface_id=4606);

INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46064, 'key', 'key', 'true', NULL, NULL, NULL, NULL, 4606, 'LEG-agent+timestamp+MD5Key', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46064 and interface_id=4606);
