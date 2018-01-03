-- auto gen by admin 2016-05-20 10:52:09
UPDATE task_schedule SET cronexpression='0 0/2 * * * ?' WHERE  job_name like '%转账超时%';
UPDATE task_schedule SET cronexpression='0 0/4 * * * ?' WHERE  job_name like '%线上支付超时%';