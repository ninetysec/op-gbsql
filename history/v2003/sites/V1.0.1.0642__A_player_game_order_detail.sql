-- auto gen by cherry 2017-12-21 14:45:43
CREATE INDEX IF NOT EXISTS player_game_order_detail_result_json_partial_idx
    ON player_game_order_detail(api_id, bet_id)
 WHERE (position('"details":null' in result_json)>0 or position('"details"' in result_json) =0);