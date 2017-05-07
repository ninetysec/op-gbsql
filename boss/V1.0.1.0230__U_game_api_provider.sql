-- auto gen by admin 2016-11-21 16:57:15
  select redo_sqls($$
    ALTER TABLE game_api_provider ADD COLUMN support_Agent bool DEFAULT false;
  $$);