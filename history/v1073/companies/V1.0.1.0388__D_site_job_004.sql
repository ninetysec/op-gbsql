-- auto gen by longer 2017-08-11 16:09:27


--站点任务:下架[site_job_004  返水未出账单任务(RakebakeNotSettledProcedureJob)]
--站点任务:下架[site_job_007	站点统计返水(SiteRakebackStatProcedureJobBySiteId)	]
DELETE from site_job_plan where job_id
in (select id from site_job where sub_job_code in ('site_job_004','site_job_007'));
DELETE from site_job where sub_job_code in ('site_job_004','site_job_007');



