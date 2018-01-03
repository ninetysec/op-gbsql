-- auto gen by admin 2016-06-30 19:27:05
DELETE FROM monitor_config WHERE method_name in('transferResult','processPlayerTransfer');

INSERT INTO  "monitor_config" ("id", "type_name", "method_name", "vo_name", "priority", "create_time", "is_invoked", "is_sync", "rule_instance", "delay_sec")
SELECT '4', 'so.wwb.gamebox.iservice.master.fund.IPlayerTransferService', 'handleTransferResult', 'so.wwb.gamebox.model.master.fund.vo.PlayerTransferVo', '1', '2015-12-29 15:13:18', '1', '1', 'transferProcess', '10'
where not EXISTS (SELECT id from monitor_config where id=4);

UPDATE monitor_config SET type_name='so.wwb.gamebox.service.master.fund.PlayerRechargeService'  , method_name='rechargeCheck' where id=6;


INSERT INTO  "task_schedule" ( "job_name", "alias_name", "job_group", "job_class", "job_method", "is_local", "status", "cronexpression", "is_sync", "description", "create_time", "update_time", "job_code", "is_system", "is_dynamic", "job_method_arg", "job_method_arg_class")
SELECT  'apiId-10-bbin-修改下单记录', NULL, NULL, 'so.wwb.gamebox.service.company.PlayerGameOrderModifierJob', 'execute', 't', '2', '0 0/5 * * * ?', 't', 'api任务', '2016-01-15 10:11:59.123', NULL, 'api-10-M', 't', 'f', '10', 'java.lang.Integer'
WHERE NOT EXISTS (SELECT job_code FROM task_schedule where job_code='api-10-M');

