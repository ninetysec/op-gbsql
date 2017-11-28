-- auto gen by alvin 2017-02-25 06:52:43
select redo_sqls($$
    ALTER TABLE player_game_order ADD COLUMN game_code varchar(64);
$$);

COMMENT ON COLUMN player_game_order.game_code  IS '游戏CODE';