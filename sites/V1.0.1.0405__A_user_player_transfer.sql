-- auto gen by cherry 2017-03-13 19:58:19
select redo_sqls($$

	ALTER TABLE user_player_transfer ADD COLUMN player_rank VARCHAR(50);

$$);

COMMENT ON COLUMN user_player_transfer.player_rank is '玩家层级';