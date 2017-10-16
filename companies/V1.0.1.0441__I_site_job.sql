-- auto gen by cherry 2017-10-16 17:02:56
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'digiccy', 'digiccy_currency', 'BTC', '1', '数字货币-比特币', NULL, 't'
where not EXISTS (SELECT id FROM sys_dict WHERE module='digiccy' AND dict_type='digiccy_currency'
AND dict_code='BTC');


INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name",
"job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit",
"fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value")
SELECT '17', NULL, 'site_job_017', '数字货币获取历史记录任务', 'so.wwb.gamebox.service.master.DigiccyHistoryJob',
'siteJob', '2', '1', '2', '2', NULL, NULL, NULL, NULL, NULL, '6'
WHERE not EXISTS(SELECT id FROM site_job where sub_job_code='site_job_017');

DELETE FROM site_job where id=18;
INSERT INTO "site_job" ("id", "prefix_job_id", "sub_job_code", "sub_job_name",
"job_class", "job_method", "job_type", "status", "job_time_type", "job_time_unit",
"fixed_month", "fixed_day", "fixed_hour", "fixed_minutes", "fixed_second", "period_value")
SELECT '18', NULL, 'site_job_018', '数字货币超时订单任务', 'so.wwb.gamebox.service.master.DigiccyRechargeJob',
'siteJob', '2', '1', '2', '2', NULL, NULL, NULL, NULL, NULL, '3'
WHERE not EXISTS(SELECT id FROM site_job where sub_job_code='site_job_018');