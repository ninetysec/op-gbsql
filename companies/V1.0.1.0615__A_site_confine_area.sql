-- auto gen by steffan 2018-05-17 19:23:36
--alter by younger
select redo_sqls($$
   ALTER TABLE "site_confine_area" ADD COLUMN "built_in" bool;
$$);
COMMENT ON COLUMN "site_confine_area"."built_in" IS '是否内置';