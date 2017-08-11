-- auto gen by longer 2017-08-08 17:35:21

--任务调度下线:和API彩池贡献金对账	(由于每个月都跑不完,将由DBA手动跑)
DELETE from task_schedule t where t.job_code = 'site_jackpot_for_api';

--任务调度下线:和站长彩池n贡献金对账(由于每个月都跑不完,将由DBA手动跑)
DELETE from 有task_schedule t where t.job_code = 'site_jackpot_for_master';

