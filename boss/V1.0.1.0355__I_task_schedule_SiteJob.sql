-- auto gen by Water 2017-06-22 20:59:05


--delete the old site job parent job,then create a new one
DELETE from task_schedule where job_code = 'site_sub_job_001';
DELETE from task_schedule where job_code = 'site_sub_job_002';

INSERT INTO task_schedule ( job_name, alias_name, job_group, job_class, job_method, is_local, status, cronexpression, is_sync, description, create_time, update_time, job_code, is_system, is_dynamic, job_method_arg, job_method_arg_class, belong_to_idc, scheduler)
select '站点任务', null, null, 'so.wwb.gamebox.service.boss.job.SiteJobParentJob', 'execute', true, '1', '0 0 0/1 * * ?', false, '站点任务-定时触发任务', '2016-12-12 21:03:30.000000', null, 'site-job-parent', false, false, null, null, 'A', 'scheduler4Site'
where not exists(select id from task_schedule t where t.job_code = 'site-job-parent');


INSERT INTO task_schedule ( job_name, alias_name, job_group, job_class, job_method, is_local, status, cronexpression, is_sync, description, create_time, update_time, job_code, is_system, is_dynamic, job_method_arg, job_method_arg_class, belong_to_idc, scheduler)
  SELECT '站点任务-外壳', null, null, 'so.wwb.gamebox.service.company.site.job.SiteJob', 'execute', true, '1', '* * * * * ? 2020 ', false, '一次性任务', now(), null, 'site-job', false, false, null, null, 'A', 'scheduler4Site'
  where not exists(select id from task_schedule t where t.job_code = 'site-job');

