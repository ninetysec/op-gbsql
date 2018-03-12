-- auto gen by linsen 2018-02-01 16:41:10
select redo_sqls($$
  CREATE INDEX app_domain_error_site_id_create_time_idx on app_domain_error(site_id,create_time);
$$);