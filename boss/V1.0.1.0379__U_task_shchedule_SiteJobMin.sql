-- auto gen by longer 2017-07-10 20:19:06

-- 站点任务,分钟级与小时级任务 执行时刻分开
UPDATE task_schedule set cronexpression = '30 0/1 * * * ?' where job_code = 'site-job-parent-min';


