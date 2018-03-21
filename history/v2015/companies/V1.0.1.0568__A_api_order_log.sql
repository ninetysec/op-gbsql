-- auto gen by linsen 2018-03-09 09:26:42
-- api_order_log by mical
 select redo_sqls($$
       ALTER TABLE "api_order_log" ADD COLUMN "interface_type" varchar(15);
      $$);