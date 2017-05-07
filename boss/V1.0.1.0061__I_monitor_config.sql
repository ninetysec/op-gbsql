-- auto gen by admin 2016-05-26 00:03:58
INSERT INTO "monitor_config" ("id", "type_name", "method_name", "vo_name", "priority", "create_time", "is_invoked", "is_sync", "rule_instance", "delay_sec")
SELECT '7', 'so.wwb.gamebox.iservice.master.fund.IPlayerTransferService', 'processPlayerTransfer', 'so.wwb.gamebox.model.master.fund.vo.PlayerTransferVo', '1', '2015-12-29 15:13:18', '1', '1', 'transferProcess', '10'
WHERE not EXISTS(SELECT id FROM monitor_config WHERE id='7');

