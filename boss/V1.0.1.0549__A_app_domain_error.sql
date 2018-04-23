-- auto gen by water 2018-04-22 22:54:20

SELECT redo_sqls($$
  alter table app_domain_error add COLUMN type VARCHAR(2);
  alter table app_domain_error add COLUMN version_name VARCHAR(12);
  alter table app_domain_error add COLUMN channel VARCHAR(20);
  alter table app_domain_error add COLUMN sys_code VARCHAR(16);
  alter table app_domain_error add COLUMN brand VARCHAR(24);
  alter table app_domain_error add COLUMN model VARCHAR(40);
$$);

COMMENT ON COLUMN app_domain_error.type IS '1: domain , 2:crash ';
COMMENT ON COLUMN app_domain_error.version_name IS 'app version';
COMMENT ON COLUMN app_domain_error.channel IS 'ios | android';
COMMENT ON COLUMN app_domain_error.sys_code IS 'app os version';
COMMENT ON COLUMN app_domain_error.brand IS '手机品牌';
COMMENT ON COLUMN app_domain_error.model IS '手机型号';