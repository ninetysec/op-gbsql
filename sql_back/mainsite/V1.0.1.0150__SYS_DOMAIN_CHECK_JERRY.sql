SELECT redo_sqls($$
  ALTER TABLE sys_domain_check ADD COLUMN site_name varchar(100);
  ALTER TABLE sys_domain_check ADD COLUMN domain_platform varchar(32);
  ALTER TABLE "sys_domain_check"
  ALTER COLUMN "check_user_id" DROP NOT NULL;

  COMMENT ON COLUMN "sys_domain_check"."site_name" IS '站点名称';
  COMMENT ON COLUMN "sys_domain_check"."domain_platform" IS '提交的域名类型：字典类型domain_platform';
$$);