-- auto gen by linsen 2018-03-29 15:11:17
-- 修改站点盈利预警任务 by younger
update site_job set job_time_unit=2,fixed_hour=null,fixed_minutes=null,period_value=10 where sub_job_code='site_job_017' ;
update site_job_plan set job_time_unit=2,fixed_hour=null,fixed_minutes=null,period_value=10 where job_id=17;