-- auto gen by longer 2016-02-16 09:28:10


SELECT redo_sqls($$
  alter TABLE sys_datasource add COLUMN filters CHARACTER VARYING(128);
$$);

COMMENT ON COLUMN sys_datasource.filters is '过滤器,使用逗号隔开,如:config,stat,wall';