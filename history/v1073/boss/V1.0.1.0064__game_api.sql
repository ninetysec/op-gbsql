-- auto gen by Alvin 2016-06-03 13:47:56
update game_api_provider set jar_version=to_char(CURRENT_TIMESTAMP, 'yyyymmddhhmmss');
update game_api_interface_request set property_name='type', default_value='' where id=943;
