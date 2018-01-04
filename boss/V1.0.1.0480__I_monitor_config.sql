-- auto gen by cherry 2018-01-01 17:21:46
INSERT INTO "monitor_config" (
id,"type_name", "method_name", "vo_name", "priority", "create_time", "is_invoked", "is_sync", "rule_instance", "delay_sec")
SELECT  10,'so.wwb.gamebox.iservice.master.fund.IPlayerRechargeService', 'rechargeCheck',
'so.wwb.gamebox.model.master.fund.vo.PlayerRechargeVo', '1', now(), '1', '1', 'rechargeProcess', '5'
WHERE not EXISTS (SELECT * FROM monitor_config WHERE id=10);


INSERT INTO "monitor_config" (
id,"type_name", "method_name", "vo_name", "priority", "create_time", "is_invoked", "is_sync", "rule_instance", "delay_sec")
SELECT  11,'so.wwb.gamebox.iservice.master.fund.IPlayerRechargeService', 'handleOnlineRechargeResult',
'so.wwb.gamebox.model.master.fund.vo.PlayerRechargeVo', '1', now(), '1', '1', 'rechargeProcess', '5'
WHERE not EXISTS (SELECT * FROM monitor_config WHERE id=11);