-- auto gen by jeff 2015-09-17 10:24:05
select redo_sqls($$
ALTER TABLE "rakeback_set" ADD COLUMN "create_time" timestamp;

COMMENT ON COLUMN "rakeback_set"."create_time" IS '创建时间';
$$);