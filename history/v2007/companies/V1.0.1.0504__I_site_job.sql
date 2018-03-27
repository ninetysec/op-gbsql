-- auto gen by cherry 2018-01-02 10:33:34
INSERT INTO "site_job" (id,"prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value")
SELECT 111,NULL, 'site_job_111', '统计单位笔数的收款账号成功率', 'so.wwb.gamebox.service.master.PayAccountRateJob', 'siteJob', '2', '1', '2', '2', NULL, NULL, NULL, NULL, NULL, '10'
WHERE not EXISTS (SELECT id from site_job where sub_job_code='site_job_111');

INSERT INTO "site_job" (id,"prefix_job_id", "sub_job_code", "sub_job_name", "job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit", "fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value")
SELECT 112,NULL, 'site_job_112', '初始化单位时间收款账号成功率', 'so.wwb.gamebox.service.master.IntelligentCashFlowJob', 'siteJob', '2', '1', '2', '2', NULL, NULL, NULL, NULL, NULL, '30'
WHERE not EXISTS (SELECT id from site_job where sub_job_code='site_job_112');