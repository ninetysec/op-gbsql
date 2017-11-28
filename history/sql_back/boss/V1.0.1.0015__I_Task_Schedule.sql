-- auto gen by lins 2015-11-05 09:38:26
SELECT redo_sqls($$
  INSERT INTO "task_schedule" ("id", "job_name", "alias_name", "job_group", "job_class", "job_method", "job_method_arg", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic")  VALUES ('1', '运营报表', NULL, NULL, 'so.wwb.gamebox.service.company.ProcedureJob', 'execute', NULL, 't', '1', '0 */1 * * * ? 2020', 'f', NULL, '2015-11-02 16:51:16', NULL, '008', 't', 'f');
$$);
