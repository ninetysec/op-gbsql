-- auto gen by tom 2015-11-22 14:54:43
select redo_sqls($$
  alter table sys_site add COLUMN site_classify_key CHARACTER VARYING(64);
$$);
update sys_site set site_classify_key='default';
ALTER TABLE "sys_site" ALTER COLUMN "site_classify_key" SET NOT NULL;
COMMENT ON COLUMN sys_site.site_classify_key is '站点类型';