-- auto gen by Water 2017-07-06 10:55:21

--站点任务:开启 站点帐务(结算)账单
update site_job set status = '1' where sub_job_code = 'site_job_011';