-- auto gen by cherry 2016-03-03 13:43:02
select redo_sqls($$
        ALTER TABLE user_player add COLUMN balance_freeze_title varchar(128);
				ALTER TABLE user_player add COLUMN balance_freeze_content text;
      $$);

COMMENT on COLUMN user_player.balance_freeze_title is '余额冻结原因标题';
COMMENT on COLUMN user_player.balance_freeze_content is '余额冻结原因内容';