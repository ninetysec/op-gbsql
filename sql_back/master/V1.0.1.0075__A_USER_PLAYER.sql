-- auto gen by jeff 2015-09-17 09:51:39
--- 玩家表添加返水方案字段
select redo_sqls($$
  ALTER TABLE user_player ADD COLUMN rakeback_id int4;
  COMMENT ON COLUMN user_player.rakeback_id IS '返水方案主键';
$$);