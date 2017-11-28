-- auto gen by cherry 2016-11-04 11:11:49
select redo_sqls($$
	alter table sys_export add column export_user_id int4;
	alter table sys_export add column export_user_site_id int4;
$$);

COMMENT ON COLUMN sys_export.export_user_id IS '导出人ID';

COMMENT ON COLUMN sys_export.export_user_site_id IS '导出人的站点ID';
