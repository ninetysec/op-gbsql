-- auto gen by cherry 2016-02-05 14:27:43
 select redo_sqls($$
      ALTER TABLE user_player ADD COLUMN backwash_title varchar(128);

			ALTER TABLE user_player add column backwash_content text;
 $$);
 COMMENT ON COLUMN user_player.backwash_title is '负数回充展示给玩家的取款标题';
COMMENT ON COLUMN user_player.backwash_content is '负数回充展示给玩家的取款内容';