-- auto gen by steffan 2018-09-17 19:29:45

 select redo_sqls($$
				ALTER TABLE "sys_site" ADD COLUMN "close_time" timestamp(6);
  $$);
COMMENT ON COLUMN "sys_site"."close_time" IS '关站时间';
