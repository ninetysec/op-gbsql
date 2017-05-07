-- auto gen by bruce 2016-09-29 23:14:47
select redo_sqls($$
  alter table sys_export add column export_end_time TIMESTAMP;
  alter table sys_export add column export_count int4;
$$);

COMMENT ON COLUMN sys_export.export_end_time IS '导出结束时间';
COMMENT ON COLUMN sys_export.export_count IS '导出记录数';