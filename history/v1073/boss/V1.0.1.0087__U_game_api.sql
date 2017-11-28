-- auto gen by Alvin 2016-07-18 12:08:15
-- 修改OG 玩家注册的限红
update game_api_provider set jar_version=to_char(CURRENT_TIMESTAMP, 'yyyymmddhhmmss') where id=7;
update game_api_interface_request set  default_value=40 where interface_id=150 and id=407;
update game_api_interface_request set  default_value=13 where interface_id=150 and id=408;