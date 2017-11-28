-- auto gen by admin 2016-06-14 14:33:43
update sys_resource set url = 'vSysDomainCheck/list.html' where id=201;

DELETE FROM monitor_config WHERE method_name in('transferResult','processPlayerTransfer');

INSERT INTO  "monitor_config" ("id", "type_name", "method_name", "vo_name", "priority", "create_time", "is_invoked", "is_sync", "rule_instance", "delay_sec")
SELECT '4', 'so.wwb.gamebox.iservice.master.fund.IPlayerTransferService', 'handleTransferResult', 'so.wwb.gamebox.model.master.fund.vo.PlayerTransferVo', '1', '2015-12-29 15:13:18', '1', '1', 'transferProcess', '10'
where not EXISTS (SELECT id from monitor_config where id=4);
