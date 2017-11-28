-- auto gen by cherry 2017-07-26 20:23:34
select redo_sqls($$    ALTER TABLE api_order_log ADD COLUMN currency character varying(5);
  $$);