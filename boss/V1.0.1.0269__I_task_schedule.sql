-- auto gen by cherry 2016-12-26 16:03:03
INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT '和API彩池贡献金对账', NULL, NULL, 'so.wwb.gamebox.service.stat.SiteApiJackpotForApiJob', 'execute', 't', '2', '0 0 16 7 * ?', 'f', '和API彩池贡献金对账', '2016-12-12 21:03:30', NULL, 'site_jackpot_for_api', 'f', 'f', null, null
WHERE not EXISTS (SELECT id FROM task_schedule WHERE job_code='site_jackpot_for_api');

INSERT INTO "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT '和站长彩池n贡献金对账', NULL, NULL, 'so.wwb.gamebox.service.stat.SiteApiJackpotForMasterJob', 'execute', 't', '2', '0 0 16 2 * ?', 'f', '和站长彩池贡献金对账', '2016-12-12 21:10:41', NULL, 'site_jackpot_for_master', 'f', 'f', null, null
WHERE NOT  EXISTS (SELECT id FROM task_schedule WHERE job_code='site_jackpot_for_master');