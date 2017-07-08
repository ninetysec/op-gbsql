-- auto gen by Water 2017-07-08 11:46:12

DELETE from task_schedule t where t.belong_to_idc = 'B';

--任务调度:只保留导出功能
--bug: 线上执行以下语句异常,要去掉not exists部分
--insert into task_schedule(job_name, alias_name, job_group, job_class, job_method, is_local, status, cronexpression, is_sync, description, create_time, update_time, job_code, is_system, is_dynamic, job_method_arg, job_method_arg_class, belong_to_idc, scheduler)
--SELECT job_name, alias_name, job_group, job_class, job_method, is_local, status, cronexpression, is_sync, description, create_time, update_time, job_code, is_system, is_dynamic, job_method_arg, job_method_arg_class, 'B', scheduler
--from task_schedule
--where job_code = 'once-003'
--and not exists( SELECT id from task_schedule  where job_code = 'once-003' and belong_to_idc = 'B');

