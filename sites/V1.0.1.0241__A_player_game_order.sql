-- auto gen by cherry 2016-08-31 21:06:43
 select redo_sqls($$
       ALTER TABLE player_game_order add COLUMN terminal varchar(9);
$$);

COMMENT on COLUMN player_game_order.terminal is '注单终端:1-PC 2-MOBILE';