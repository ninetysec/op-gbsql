-- auto gen by linsen 2018-06-28 20:47:21
-- 修改app_servers字段 by cherry
select redo_sqls($$
    ALTER TABLE sys_site ALTER COLUMN app_servers TYPE varchar(256);
$$);