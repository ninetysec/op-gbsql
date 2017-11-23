-- auto gen by water 2017-11-21 20:59:34
--SQL:为虚拟机房添加列表导出任务，方便测试
insert into task_schedule( job_name, alias_name, job_group, job_class, job_method, is_local, status, cronexpression, is_sync, description, create_time, update_time, job_code, is_system, is_dynamic, job_method_arg, job_method_arg_class, belong_to_idc, scheduler)
  SELECT  job_name, alias_name, job_group, job_class, job_method, is_local, status, cronexpression, is_sync, description, create_time, update_time, job_code, is_system, is_dynamic, job_method_arg, job_method_arg_class, 'v', scheduler
  from task_schedule
  where job_code = 'once-003'
        and not exists(
      SELECT id from task_schedule where job_code = 'once-003' and belong_to_idc = 'v'
  );




