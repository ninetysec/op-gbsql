-- auto gen by wayne 2017-03-22 16:50:13
select redo_sqls($$
    ALTER TABLE "task_schedule" ADD COLUMN "belong_to_idc" varchar(10);
  $$);

update task_schedule set belong_to_idc='A' where belong_to_idc is null;