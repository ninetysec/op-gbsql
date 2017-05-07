-- auto gen by bruce 2016-10-31 22:37:55
select redo_sqls($$
    ALTER TABLE sys_search_template  ADD COLUMN user_id INT4;
$$);
COMMENT ON COLUMN sys_search_template.user_id IS '用户Id';