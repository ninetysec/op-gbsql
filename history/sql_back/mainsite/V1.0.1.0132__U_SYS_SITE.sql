-- auto gen by tom 2015-12-02 15:34:46
select redo_sqls($$
    ALTER TABLE "sys_site" ADD COLUMN "maintain_start_time" timestamp;
    ALTER TABLE "sys_site" ADD COLUMN "maintain_end_time" timestamp;
    ALTER TABLE "sys_site" ADD COLUMN "maintain_reason" varchar(100);
    ALTER TABLE "sys_site" ADD COLUMN "maintain_operate_id" int4;
    ALTER TABLE "sys_site" ADD COLUMN "maintain_operate_time" timestamp;

    comment on column "sys_site"."maintain_start_time" is '维护开始时间';
    comment on column "sys_site"."maintain_end_time" is '维护结束时间';
    comment on column "sys_site"."maintain_reason" is '维护原因';
    comment on column "sys_site"."maintain_operate_id" is '维护者';
    comment on column "sys_site"."maintain_operate_time" is '维护操作时间';
$$);