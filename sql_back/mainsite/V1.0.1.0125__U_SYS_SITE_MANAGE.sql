-- auto gen by tom 2015-11-27 15:55:49
select redo_sqls($$
    ALTER TABLE "sys_site" ADD COLUMN "template_code" varchar(32);
$$);