-- auto gen by linsen 2018-05-04 09:05:29
-- api_order_log添加字段 by mical
 select redo_sqls($$
       ALTER TABLE "api_order_log" ADD COLUMN "site_id" varchar(15);
      $$);

COMMENT ON COLUMN api_order_log.site_id IS '站点id';