-- auto gen by wayne 2016-10-22 14:09:12

select redo_sqls($$
    ALTER TABLE game_api_log ALTER COLUMN "type" TYPE VARCHAR(20);
  $$);
