-- auto gen by steffan 2018-10-10 09:55:17  update by snow
update player_game_order a set stat_time =(select
   to_timestamp(substring(result_json,position('"matchDate":' in result_json)+13,19),'YYYY-MM-DD HH24:MI:SS')::TIMESTAMP + INTERVAL '4 hours'
  from player_game_order_detail b where api_id=12 and b.bet_id=a.bet_id);