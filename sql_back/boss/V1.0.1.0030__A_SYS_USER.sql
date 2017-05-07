-- auto gen by jeff 2015-12-16 15:57:23
select redo_sqls($$
ALTER TABLE sys_user ADD COLUMN freeze_user int4;
$$);
select redo_sqls($$
ALTER TABLE sys_user ADD COLUMN disabled_user int4;
$$);
select redo_sqls($$
ALTER TABLE sys_user ADD COLUMN disabled_time timestamp;
$$);
select redo_sqls($$
ALTER TABLE sys_user ADD COLUMN freeze_time timestamp;
$$);

COMMENT ON COLUMN "sys_user"."freeze_time" IS '冻结操作时间';
COMMENT ON COLUMN "sys_user"."freeze_user" IS '冻结操作人id';

COMMENT ON COLUMN "sys_user"."disabled_user" IS '停用操作人id';

COMMENT ON COLUMN "sys_user"."disabled_time" IS '停用时间';