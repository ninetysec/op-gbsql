-- auto gen by Water 2017-07-21 11:17:18

--调度任务:删除无用的任务
DELETE from task_schedule where status = '2' and (scheduler = 'scheduler4Default' or scheduler is null);

--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--以下SQL清理调度器改版后,所有残留的调度器及相关内容
--+++++++++++++++++++++++++++++++++++++++++++++++++++++++++

--调度器:删除一种调度器中的所有trigger
DELETE from qrtz_cron_triggers where sched_name like 'scheduler%';
DELETE from qrtz_simple_triggers where sched_name like 'scheduler%';
DELETE from qrtz_triggers where sched_name like 'scheduler%';
DELETE from qrtz_job_details where sched_name like 'scheduler%';
DELETE from qrtz_fired_triggers where sched_name like 'scheduler%';

--调度器:删除一种调度器,其它相关数据
DELETE from qrtz_locks where sched_name like 'scheduler%';
DELETE from qrtz_job_details where sched_name like 'scheduler%';
DELETE from qrtz_scheduler_state where sched_name like 'scheduler%';
