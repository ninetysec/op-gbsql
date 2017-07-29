-- auto gen by Water 2017-07-29 10:23:53

--补全参数
update task_schedule set job_method_arg_class = 'java.lang.String[]',job_method_arg = '[]'
where job_code = 'site-job-parent';
