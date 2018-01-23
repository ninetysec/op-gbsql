-- auto gen by george 2018-01-19 15:37:22
select redo_sqls($$
   ALTER TABLE "site_bill_template"
   ADD COLUMN "template_type" varchar(2),
   ADD COLUMN "file_type" varchar(64);
$$);

COMMENT ON COLUMN "site_bill_template"."template_type" IS '模板类型';
COMMENT ON COLUMN "site_bill_template"."file_type" IS '文件类型';