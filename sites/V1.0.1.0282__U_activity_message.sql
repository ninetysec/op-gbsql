-- auto gen by bruce 2016-10-09 20:58:36
select redo_sqls($$
  ALTER TABLE activity_message ALTER COLUMN start_time DROP NOT NULL;
  ALTER TABLE activity_message ALTER COLUMN end_time DROP NOT NULL;
$$);
