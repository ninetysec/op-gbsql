-- auto gen by tony 2017-12-13 15:03:31
select redo_sqls($$
    ALTER TABLE sys_datasource ADD COLUMN is_virtual_idc boolean DEFAULT FALSE ;
  $$);
select redo_sqls($$
    ALTER TABLE sys_report_datasource ADD COLUMN is_virtual_idc boolean DEFAULT FALSE ;
  $$);
update sys_datasource set is_virtual_idc=true,idc='A' where idc='V';