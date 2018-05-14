-- auto gen by water 2018-04-23 20:00:50

select redo_sqls($$
  ALTER TABLE sys_site add COLUMN app_servers VARCHAR(90);
$$);

COMMENT ON COLUMN sys_site.app_servers is 'APP server ip,separate by ,';
