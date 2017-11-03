-- auto gen by marz 2017-11-03 14:26:06
update player_game_order set result_json='['||result_json||']' where position( '{' in result_json) = 1;