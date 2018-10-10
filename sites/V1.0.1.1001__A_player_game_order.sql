-- auto gen by steffan 2018-10-10 09:53:09  alter by snow
 select redo_sqls($$
  alter table player_game_order add column stat_time TIMESTAMP(6);
  $$);
COMMENT ON COLUMN player_game_order.stat_time IS '输赢报表统计时间';