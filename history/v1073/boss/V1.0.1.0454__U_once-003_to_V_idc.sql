-- auto gen by water 2017-11-22 18:38:00

--V must upper case
update task_schedule set belong_to_idc= 'V' where job_code = 'once-003' and belong_to_idc = 'v';


--Copy SiteJob to IDC:V
insert into task_schedule(job_name, alias_name, job_group, job_class, job_method, is_local, status, cronexpression, is_sync, description, create_time, update_time, job_code, is_system, is_dynamic, job_method_arg, job_method_arg_class, belong_to_idc, scheduler)
  SELECT job_name, alias_name, job_group, job_class, job_method, is_local, status, cronexpression, is_sync, description, create_time, update_time, job_code, is_system, is_dynamic, job_method_arg, job_method_arg_class, 'V', scheduler
  from task_schedule
  where job_code like 'site-job%' and belong_to_idc = 'A'
        and not exists(select id from task_schedule where job_code like 'site-job%' and belong_to_idc = 'V');