-- auto gen by cherry 2016-12-07 15:09:22
select redo_sqls($$
    ALTER TABLE ctt_announcement ADD COLUMN display BOOLEAN DEFAULT TRUE;
  $$);
