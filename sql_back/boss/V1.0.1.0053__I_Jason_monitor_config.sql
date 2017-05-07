-- auto gen by Jason 2016-01-13 10:03:45


-- ----------------------------
-- Records of monitor_config
-- ----------------------------
INSERT INTO "monitor_config" VALUES ('1', 'so.wwb.gamebox.iservice.master.fund.IPlayerRechargeService', 'savePlayerRecharge', 'so.wwb.gamebox.model.master.fund.vo.PlayerRechargeVo', '2', '2015-12-23 14:08:48', '1', '2', 'rechargeProcess', '30');
INSERT INTO "monitor_config" VALUES ('2', 'so.wwb.gamebox.iservice.master.fund.IPlayerRechargeService', 'updatePlayerRecharge', 'so.wwb.gamebox.model.master.fund.vo.PlayerRechargeVo', '1', '2015-11-18 15:15:00', '1', '1', 'quotaProcess', '5');
INSERT INTO "monitor_config" VALUES ('3', 'so.wwb.gamebox.service.boss.taskschedule.TaskRunRecordService', 'update', 'so.wwb.gamebox.model.boss.taskschedule.vo.TaskRunRecordVo', '1', null, '0', '1', 'scheduleProcess', '10');
INSERT INTO "monitor_config" VALUES ('4', 'so.wwb.gamebox.iservice.master.fund.IPlayerTransferService', 'savePlayerTransferService', 'so.wwb.gamebox.model.master.fund.vo.PlayerTransferVo', '1', '2015-12-29 15:13:18', '1', '1', 'transferProcess', '10');
INSERT INTO "monitor_config" VALUES ('5', 'so.wwb.gamebox.service.master.player.PlayerGameOrderService', 'fetchRecord', 'so.wwb.gamebox.model.master.player.vo.PlayerGameOrderListVo', '1', '2015-12-29 15:13:18', '0', '1', 'siteQuotaProcess', '5');


-- ----------------------------
-- Records of monitor_config_relation
-- ----------------------------
INSERT INTO "monitor_config_relation" VALUES ('1', null, '10001', '充值创建', '0');
INSERT INTO "monitor_config_relation" VALUES ('2', '1', '10001', '充值返回更新', '0');
INSERT INTO "monitor_config_relation" VALUES ('3', null, '20001', '定时跑批监控点1', '1');
INSERT INTO "monitor_config_relation" VALUES ('4', null, '10002', '转账创建', '0');
INSERT INTO "monitor_config_relation" VALUES ('5', null, '10003', '玩家游戏记录获取', '0');
INSERT INTO "monitor_config_relation" VALUES ('6', '4', '10002', '转账更新', '0');