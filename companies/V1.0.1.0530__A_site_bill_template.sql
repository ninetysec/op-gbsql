-- auto gen by george 2018-01-24 19:11:55
--导出模板添加语言版本
select redo_sqls($$
   ALTER TABLE "site_bill_template"  ADD COLUMN "locale" varchar(16);
$$);

COMMENT ON COLUMN "site_bill_template"."locale" IS '语言';