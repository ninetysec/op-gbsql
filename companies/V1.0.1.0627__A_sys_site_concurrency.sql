-- auto gen by water 2018-05-24 19:37:24

SELECT redo_sqls($$
  alter table sys_site add COLUMN  concurrency INT4;
  COMMENT ON COLUMN sys_site.concurrency is '站点请求并发数';
$$);

