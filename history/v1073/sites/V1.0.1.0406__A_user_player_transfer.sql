-- auto gen by cherry 2017-03-14 10:37:47
select redo_sqls($$

	ALTER TABLE user_player_transfer ADD COLUMN player_rank_id int4;

$$);

COMMENT ON COLUMN user_player_transfer.player_rank_id is '玩家层级ID';
