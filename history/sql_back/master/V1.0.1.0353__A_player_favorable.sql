-- auto gen by cherry 2016-01-26 15:05:03
 select redo_sqls($$
        ALTER TABLE player_favorable add COLUMN player_id int4;
      $$);

COMMENT ON COLUMN player_favorable.player_id IS '玩家id';