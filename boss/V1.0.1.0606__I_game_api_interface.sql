-- auto gen by linsen 2018-08-30 14:47:31
-- 乐游棋牌 by snow

-- game_api_interface 4607
INSERT INTO game_api_interface (id, protocol, api_action, local_action, http_method, remarks, param_class, result_class, request_content_type, response_content_type, provider_id, ext_json)
  SELECT 4607, 'HTTPS', NULL, 'checkTransfer', 'GET', 'LEG-查询转账', 'org.soul.model.gameapi.param.CheckTransferParam', 'org.soul.model.gameapi.result.CheckTransferResult', 'JSON', 'JSON', 46, NULL
  WHERE NOT EXISTS(select id from game_api_interface where id=4607 and provider_id=46);

-- checkTransfer
INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46071, 'agent', 'agent', 'true', NULL, NULL, NULL, NULL, 4607, 'LEG-代理编号', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46071 and interface_id=4607);

INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46072, 'timestamp', 'timestamp', 'true', NULL, NULL, NULL, NULL, 4607, 'LEG-当前时间戳', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46072 and interface_id=4607);

INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46073, 'param', 'param', 'true', NULL, NULL, NULL, NULL, 4607, 'LEG-操作类型、玩家账号、金额、流水号、玩家ip、站点标识符、游戏id', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46073 and interface_id=4607);

INSERT INTO game_api_interface_request (id, api_field_name, property_name, required, min_length, max_length, reg_exp, default_value, interface_id, remarks, comment, min_value, max_value)
  SELECT 46074, 'key', 'key', 'true', NULL, NULL, NULL, NULL, 4607, 'LEG-agent+timestamp+MD5Key', NULL, NULL, NULL
  WHERE NOT EXISTS(select id from game_api_interface_request where id=46074 and interface_id=4607);