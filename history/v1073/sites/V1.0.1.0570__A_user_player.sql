-- auto gen by george 2017-10-26 11:04:47
select redo_sqls($$
  alter table user_player add column channel_terminal VARCHAR(10);
$$);
COMMENT ON COLUMN user_player.channel_terminal IS '来源终端';