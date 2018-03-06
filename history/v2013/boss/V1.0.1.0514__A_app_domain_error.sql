-- auto gen by linsen 2018-02-04 17:54:06
select redo_sqls($$
  ALTER TABLE app_domain_error ADD COLUMN mark VARCHAR(32);
$$);
COMMENT ON COLUMN app_domain_error.mark IS '标志';