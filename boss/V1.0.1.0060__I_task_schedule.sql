-- auto gen by admin 2016-05-25 20:05:34
INSERT INTO  "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT  '站点-1-总代占成', NULL, NULL, 'so.wwb.gamebox.service.master.AgentOccupyProcedureJob', 'execute', 't', '1', '0 30 16 2 * ?', 't', '站点任务', '2015-11-02 16:51:16', NULL, 'site-1-014', 'f', 'f', '1', 'java.lang.Integer'
WHERE  not EXISTS (SELECT job_code FROM task_schedule WHERE job_code='site-1-014');

INSERT INTO  "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT  '站点-71-总代占成', NULL, NULL, 'so.wwb.gamebox.service.master.AgentOccupyProcedureJob', 'execute', 't', '1', '0 30 16 2 * ?', 't', '站点任务', '2015-11-02 16:51:16', NULL, 'site-71-014', 'f', 'f', '71', 'java.lang.Integer'
WHERE  not EXISTS (SELECT job_code FROM task_schedule WHERE job_code='site-71-014');

INSERT INTO  "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT  '站点-73-总代占成', NULL, NULL, 'so.wwb.gamebox.service.master.AgentOccupyProcedureJob', 'execute', 't', '1', '0 30 16 2 * ?', 't', '站点任务', '2015-11-02 16:51:16', NULL, 'site-73-014', 'f', 'f', '73', 'java.lang.Integer'
WHERE  not EXISTS (SELECT job_code FROM task_schedule WHERE job_code='site-73-014');

INSERT INTO  "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT  '站点-74-总代占成', NULL, NULL, 'so.wwb.gamebox.service.master.AgentOccupyProcedureJob', 'execute', 't', '1', '0 30 16 2 * ?', 't', '站点任务', '2015-11-02 16:51:16', NULL, 'site-74-014', 'f', 'f', '74', 'java.lang.Integer'
WHERE  not EXISTS (SELECT job_code FROM task_schedule WHERE job_code='site-74-014');

INSERT INTO  "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT  '站点-75-总代占成', NULL, NULL, 'so.wwb.gamebox.service.master.AgentOccupyProcedureJob', 'execute', 't', '1', '0 30 16 2 * ?', 't', '站点任务', '2015-11-02 16:51:16', NULL, 'site-75-014', 'f', 'f', '75', 'java.lang.Integer'
WHERE  not EXISTS (SELECT job_code FROM task_schedule WHERE job_code='site-75-014');

INSERT INTO  "task_schedule" ("job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT  '站点-76-总代占成', NULL, NULL, 'so.wwb.gamebox.service.master.AgentOccupyProcedureJob', 'execute', 't', '1', '0 30 16 2 * ?', 't', '站点任务', '2015-11-02 16:51:16', NULL, 'site-74-014', 'f', 'f', '76', 'java.lang.Integer'
WHERE  not EXISTS (SELECT job_code FROM task_schedule WHERE job_code='site-76-014');

UPDATE task_schedule set cronexpression='0 0 17 2 * ?' , job_class='so.wwb.gamebox.service.stat.StationBillProcedureJob' WHERE job_name LIKE '%站长站点账务(结算)账单%';

UPDATE task_schedule set cronexpression='0 0 16 2 * ?' , job_class='so.wwb.gamebox.service.stat.TopAgentBillProcedureJob' WHERE job_name LIKE '%站点总代账务(结算)账单%';

UPDATE task_schedule set cronexpression='0 30 18 * * ?'  WHERE job_name like'%返佣未出账单任务%';

UPDATE task_schedule set cronexpression=' 0 30 18 * * ?'  WHERE job_name like'%返佣周期任务%';

UPDATE task_schedule SET cronexpression='0 0 19 * * ?' where job_name like '%推荐奖励周期任务%';

UPDATE task_schedule set cronexpression='0 0/4 * * * ?' WHERE  job_name like '%下单记录%' AND cronexpression='0 0/5 * * * ?';

