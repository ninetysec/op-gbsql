-- auto gen by admin 2016-04-20 21:04:02
DELETE FROM task_schedule WHERE job_code='once-004';

UPDATE task_schedule set  cronexpression='0 0 16 * * ?' WHERE job_code LIKE '%-010';
