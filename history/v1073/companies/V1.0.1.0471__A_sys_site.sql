-- auto gen by george 2017-11-15 19:03:15
SELECT redo_sqls($$
   ALTER TABLE "sys_site"
ADD COLUMN "has_use_profit" numeric(20,2),
ADD COLUMN "credit_line" numeric(20,2);

COMMENT ON COLUMN "sys_site"."has_use_profit" IS '已使用额度';
COMMENT ON COLUMN "sys_site"."credit_line" IS '授信额度';
$$);