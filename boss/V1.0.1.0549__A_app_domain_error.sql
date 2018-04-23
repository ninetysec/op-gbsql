-- auto gen by water 2018-04-22 22:54:20

SELECT redo_sqls($$
  alter table app_domain_error add COLUMN type VARCHAR(2);
  alter table app_domain_error add COLUMN version_name VARCHAR(12);
  alter table app_domain_error add COLUMN channel VARCHAR(20);
  alter table app_domain_error add COLUMN sys_code VARCHAR(16);
  alter table app_domain_error add COLUMN brand VARCHAR(24);
  alter table app_domain_error add COLUMN model VARCHAR(40);
$$);