-- auto gen by longer 2017-07-21 10:09:59

-- 拆分两个分钟级任务
update task_schedule set
  job_code = 'site-job-online-recharge',
  job_name = '站点任务-在线支付超时',
  job_method_arg = '["site_job_101"]',
  cronexpression = '30 0/2 * * * ?'
where job_code = 'site-job-parent-min';

insert into task_schedule(
  job_name, alias_name, job_group, job_class, job_method, is_local, status, cronexpression, is_sync, description, create_time, update_time, job_code, is_system, is_dynamic, job_method_arg, job_method_arg_class, belong_to_idc, scheduler)
  SELECT '站点任务-转帐超时', alias_name, job_group, job_class, job_method, is_local, status, '10 0/1 * * * ?', is_sync, description, create_time, update_time, 'site-job-transfer', is_system, is_dynamic, '["site_job_102"]', job_method_arg_class, belong_to_idc, scheduler
  from task_schedule
  where job_code = 'site-job-online-recharge'
        and not exists (select id from task_schedule where job_code = 'site-job-transfer');
