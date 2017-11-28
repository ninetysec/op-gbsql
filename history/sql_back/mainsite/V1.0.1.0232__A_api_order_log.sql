-- auto gen by cherry 2016-01-14 09:06:11
 select redo_sqls($$
 ALTER TABLE api_order_log ADD COLUMN is_need_account bool DEFAULT FALSE;
      $$);
COMMENT ON COLUMN api_order_log.is_need_account IS'下单是否需要账号，默认为false';