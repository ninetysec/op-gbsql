-- auto gen by cherry 2017-03-13 10:24:36
update site_sub_job set job_time_type = '1',job_time_unit=5,fixed_day=3,fixed_hour=1,fixed_minutes=0,fixed_second=0 where id in(13,14);

update site_sub_job set job_time_type = '1',job_time_unit=4,fixed_hour=1,fixed_minutes=0,fixed_second=0 where id in (2,15,4,5,6,7,8,9,10,11,12,16);

update site_sub_job set job_time_type = '2',job_time_unit=3,fixed_day=3,fixed_hour=NULL,fixed_minutes=NULL,fixed_second=NULL,period_value=1 where id = 3;

update site_sub_job set prefix_job_id = 11 where id in(12,13);

update site_sub_job set job_time_unit = '5',fixed_day = 3 WHERE id = 12;

INSERT INTO "site_sub_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value")
SELECT '17', '11', 'site_job_017', '代理返佣任务', 'so.wwb.gamebox.service.master.AgentRebateJob', 'siteJob', '1', '1', '1', '5', NULL, '3', '1', '0', '0', NULL
WHERE not EXISTS (SELECT id from site_sub_job WHERE id=17);