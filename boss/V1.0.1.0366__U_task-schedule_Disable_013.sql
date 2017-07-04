-- auto gen by Water 2017-07-04 15:02:43

-- 调度任务:禁用:返水api基础数据任务
update task_schedule set status = '2' where task_schedule.job_class = 'so.wwb.gamebox.service.master.RakebackApiBaseProcedureJob';
