-- auto gen by admin 2016-04-27 20:26:08
 select redo_sqls($$
      ALTER TABLE player_game_order ADD COLUMN action_id_json text;
      $$);

COMMENT ON COLUMN player_game_order.action_id_json is 'action_id_json，格式为action_id:profitAmount';