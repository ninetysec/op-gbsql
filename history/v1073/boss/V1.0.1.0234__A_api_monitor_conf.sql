-- auto gen by admin 2016-11-25 11:41:56
select redo_sqls($$
    ALTER TABLE api_monitor_trans_conf ADD COLUMN site_id int4;
  $$);