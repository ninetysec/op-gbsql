-- auto gen by cherry 2018-01-11 20:31:28
INSERT INTO "monitor_config" ("id", "type_name", "method_name", "vo_name", "priority", "create_time", "is_invoked", "is_sync", "rule_instance", "delay_sec")
SELECT '12', 'so.wwb.gamebox.iservice.master.fund.IPlayerRechargeService', 'savePlayerRecharge', 'so.wwb.gamebox.model.master.fund.vo.PlayerRechargeVo', '1', '2018-01-04 16:17:41.926526', '1', '1', 'rechargeProcess', '5'
WHERE not EXISTS(SELECT * FROM monitor_config where id=12);