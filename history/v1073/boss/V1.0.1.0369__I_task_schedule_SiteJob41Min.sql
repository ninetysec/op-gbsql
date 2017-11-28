-- auto gen by Water 2017-07-04 20:12:26

INSERT INTO task_schedule ( job_name, alias_name, job_group, job_class, job_method, is_local, status, cronexpression, is_sync, description, create_time, update_time, job_code, is_system, is_dynamic, job_method_arg, job_method_arg_class, belong_to_idc, scheduler)
  select '站点任务-分钟级', null, null, 'so.wwb.gamebox.service.boss.job.SiteJobParentJob', 'execute', true, '1', '0 0/1 * * * ?', false, '站点任务-分钟级定时触发', '2016-12-12 21:03:30.000000', null, 'site-job-parent-min', false, false, '["site_job_101","site_job_102"]','java.lang.String[]', 'A', 'scheduler4Site'
  where not exists(select id from task_schedule t where t.job_code = 'site-job-parent-min');



