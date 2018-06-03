-- auto gen by linsen 2018-05-09 17:28:43
-- 修改api_name字段长度 by zain
select redo_sqls($$
    ALTER TABLE game_api_log ALTER COLUMN "api_name" TYPE VARCHAR(20);
  $$);