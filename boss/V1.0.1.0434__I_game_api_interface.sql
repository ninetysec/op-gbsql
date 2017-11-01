-- auto gen by george 2017-11-01 15:24:51
 INSERT INTO "game_api_interface" ("id", "protocol", "api_action", "local_action", "http_method", "remarks", "param_class", "result_class", "request_content_type", "response_content_type", "provider_id", "ext_json")
  SELECT '308', 'HTTP', 'launcher/tx', 'extend', 'GET', 'NEW_MG-获取游戏平台游戏详情链接', 'org.soul.model.gameapi.param.ExtendParam', 'org.soul.model.gameapi.result.ExtendResult', 'FORM', 'JSON', '3', ''
  WHERE 308 NOT IN(SELECT id FROM game_api_interface WHERE id=308);