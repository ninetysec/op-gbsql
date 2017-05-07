-- auto gen by longer 2016-03-22 09:07:16

SELECT redo_sqls($$
  alter TABLE sys_datasource add COLUMN connection_properties CHARACTER VARYING(512);
$$);

COMMENT ON COLUMN sys_datasource.connection_properties IS '链接参数';
