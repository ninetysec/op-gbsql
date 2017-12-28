-- auto gen by water 2017-12-28 17:47:20

--
INSERT into task_schedule( job_name, alias_name, job_group, job_class, job_method, is_local, status, cronexpression, is_sync, description, create_time, update_time, job_code, is_system, is_dynamic, job_method_arg, job_method_arg_class, belong_to_idc, scheduler)
  select job_name, alias_name, job_group, job_class, job_method, is_local, status, cronexpression, is_sync, description, create_time, update_time, job_code, is_system, is_dynamic, job_method_arg, job_method_arg_class,'V',scheduler
  from task_schedule
  where job_code = 'once-005' and belong_to_idc = 'A'
        and not exists(select id from task_schedule where job_code = 'once-005' and belong_to_idc = 'V');


INSERT into task_schedule( job_name, alias_name, job_group, job_class, job_method, is_local, status, cronexpression, is_sync, description, create_time, update_time, job_code, is_system, is_dynamic, job_method_arg, job_method_arg_class, belong_to_idc, scheduler)
  select job_name, alias_name, job_group, job_class, job_method, is_local, status, cronexpression, is_sync, description, create_time, update_time, job_code, is_system, is_dynamic, job_method_arg, job_method_arg_class,'B',scheduler
  from task_schedule
  where job_code = 'once-005' and belong_to_idc = 'A'
        and not exists(select id from task_schedule where job_code = 'once-005' and belong_to_idc = 'B');