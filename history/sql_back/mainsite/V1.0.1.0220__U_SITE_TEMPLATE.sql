-- auto gen by tom 2016-01-08 11:57:44
COMMENT ON COLUMN "site_template"."code" IS '模板code,使用模板code获取图片路径(站点使用)';

select redo_sqls($$
    ALTER TABLE "site_template" ADD COLUMN "pic_path" varchar(1000);
    COMMENT ON COLUMN "site_template"."pic_path" IS '图片路径';
  $$);

