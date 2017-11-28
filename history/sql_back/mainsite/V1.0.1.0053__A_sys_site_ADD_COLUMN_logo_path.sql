-- auto gen by longer 2015-10-26 10:36:07


select redo_sqls($$
  alter table sys_site add COLUMN logo_path CHARACTER VARYING(255);
$$);

COMMENT ON COLUMN sys_site.logo_path is 'Logo路径';