-- auto gen by Water 2017-06-19 16:01:30

-- for test
--update task_schedule set scheduler = '' where scheduler is not null;

-- update some records only exec once
update task_schedule set scheduler = 'scheduler4Once' where job_code like 'once%';

-- update some records 4 lottery gather job
update task_schedule set scheduler = 'scheduler4Lottery' where job_code like 'lottery%';

-- update some records 4 api gather job
update task_schedule set scheduler = 'scheduler4Api' where job_class like 'so.wwb.gamebox.service.company.PlayerGameOrder%';

-- update other records
update task_schedule set scheduler = 'scheduler4Default' where scheduler is null;
