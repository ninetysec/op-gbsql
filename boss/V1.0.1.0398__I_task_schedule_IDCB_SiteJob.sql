-- auto gen by Water 2017-08-07 19:41:58

--IDC:B上线站点任务
insert into task_schedule(job_name, alias_name, job_group, job_class, job_method, is_local, status, cronexpression, is_sync, description, create_time, update_time, job_code, is_system, is_dynamic, job_method_arg, job_method_arg_class, belong_to_idc, scheduler)
  SELECT job_name, alias_name, job_group, job_class, job_method, is_local, status, cronexpression, is_sync, description, create_time, update_time, job_code, is_system, is_dynamic, job_method_arg, job_method_arg_class, 'B', scheduler
  from task_schedule t
  where t.job_code LIKE 'site-job%'
        and not exists(
      select id
      from task_schedule a
      where a.job_code
            in('site-job','site-job-parent','site-job-transfer','site-job-online-recharge')
            and a.belong_to_idc = 'B'
  );