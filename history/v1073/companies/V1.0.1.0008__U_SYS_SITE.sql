-- auto gen by tom 2016-02-15 17:38:08
select redo_sqls($$
    ALTER TABLE "sys_site" ADD CONSTRAINT "unique_code" UNIQUE ("code");
    COMMENT ON CONSTRAINT "unique_code" ON "sys_site" IS '唯一性';
  $$);