-- auto gen by Water 2017-07-04 20:20:28

--站点任务:新增两个短时间的站点任务
INSERT INTO site_job (id, prefix_job_id, sub_job_code, sub_job_name, job_class, job_method, job_type, status, job_time_type, job_time_unit, fixed_month, fixed_day, fixed_hour, fixed_minutes, fixed_second, period_value)
SELECT 101, null, 'site_job_101', '线上支付超时订单', 'so.wwb.gamebox.service.master.site.job.OnlineRechargeSiteJob', 'siteJob', '2', '1', '2', '2', null, null, null, 1, 0,'1'
WHERE not exists(SELECT id from site_job where id = 101);

INSERT INTO site_job (id, prefix_job_id, sub_job_code, sub_job_name, job_class, job_method, job_type, status, job_time_type, job_time_unit, fixed_month, fixed_day, fixed_hour, fixed_minutes, fixed_second, period_value)
SELECT 102, null, 'site_job_102', '转帐超时订单', 'so.wwb.gamebox.service.master.site.job.TransferSiteJob', 'siteJob', '2', '1', '2', '2', null, null, null, 1, 0, '1'
WHERE not exists(SELECT id from site_job where id = 102);



