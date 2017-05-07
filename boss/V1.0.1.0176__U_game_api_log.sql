-- auto gen by wayne 2016-10-12 14:08:12

select redo_sqls($$
    ALTER TABLE "game_api_log" ALTER COLUMN "api_status_desc" TYPE char(200);
  $$);
