-- auto gen by tom 2015-11-22 15:16:44
select redo_sqls($$
  alter table sys_site add COLUMN account_suffix CHARACTER VARYING(9);
$$);
update sys_site set account_suffix='@abc';
ALTER TABLE "sys_site" ALTER COLUMN "account_suffix" SET NOT NULL;
COMMENT ON COLUMN sys_site.account_suffix is '账号后缀';

ALTER TABLE sys_site DROP COLUMN IF EXISTS account_suffix;