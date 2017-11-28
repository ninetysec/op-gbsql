-- auto gen by admin 2016-04-22 21:52:29
INSERT INTO "user_task_reminder" ("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
SELECT 'rebate', '2015-11-10 18:01:14', '0', '/operation/rebate/list.html', 'examine', '返佣结算审批', NULL, 'audit'
WHERE 'rebate' not in(SELECT dict_code FROM  user_task_reminder WHERE dict_code='rebate');

INSERT INTO "user_task_reminder" ("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
SELECT 'orange', '2016-01-15 07:25:59.416017', '0', NULL, 'pay', '橙色预警', NULL, 'warm'
WHERE 'orange' not in(SELECT dict_code FROM  user_task_reminder WHERE dict_code='orange');

INSERT INTO "user_task_reminder" ("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
SELECT 'red', '2016-01-15 07:26:21.790209', '0', '', 'pay', '红色预警', NULL, 'warm'
WHERE 'red' not in(SELECT dict_code FROM  user_task_reminder WHERE dict_code='red');

INSERT INTO "user_task_reminder" ("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
SELECT 'profitYellow', '2015-12-28 09:54:48', '0', NULL, 'profit', '盈利黄色预警', NULL, ''
WHERE 'profitYellow' not in(SELECT dict_code FROM  user_task_reminder WHERE dict_code='profitYellow');

INSERT INTO "user_task_reminder" ("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
SELECT 'profitRed', '2015-12-28 09:54:48', '0', NULL, 'profit', '盈利红色预警', NULL, ''
WHERE 'profitRed' not in(SELECT dict_code FROM  user_task_reminder WHERE dict_code='profitRed');

INSERT INTO "user_task_reminder" ("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
SELECT 'station', '2015-11-10 18:01:14', '0','/operation/stationbill/list.html', 'bill', '站务账单', NULL, 'notice'
WHERE 'station' not in(SELECT dict_code FROM  user_task_reminder WHERE dict_code='station');

INSERT INTO "user_task_reminder" ("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
SELECT 'topAgentStation', '2015-11-10 18:01:14', '0', '/operation/stationbill/generalBill.html', 'bill', '总代账单', NULL, 'notice'
WHERE 'topAgentStation' not in(SELECT dict_code FROM  user_task_reminder WHERE dict_code='topAgentStation');

INSERT INTO "user_task_reminder" ("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
SELECT 'profitOrange', '2016-01-14 08:44:14.691942', '0', NULL, 'profit', '盈利橙色预警', NULL, ''
WHERE 'profitOrange' not in(SELECT dict_code FROM  user_task_reminder WHERE dict_code='profitOrange');

INSERT INTO "user_task_reminder" ("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
SELECT 'freeze', '2016-01-15 07:28:43.866631', '0', '', 'pay', '红色预警', NULL, 'warm'
WHERE 'freeze' not in(SELECT dict_code FROM  user_task_reminder WHERE dict_code='freeze');

INSERT INTO "user_task_reminder" ("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
SELECT 'twoSituation', '2015-12-28 09:54:48', '0', '', 'pay', '情况二', NULL, 'warm'
WHERE 'twoSituation' not in(SELECT dict_code FROM  user_task_reminder WHERE dict_code='twoSituation');

INSERT INTO "user_task_reminder" ("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
SELECT 'agentWithdraw', '2016-01-15 07:13:21.749553', '0', '/fund/vAgentWithdrawOrder/agentList.html', 'examine', '代理取款审批', NULL, 'draw'
WHERE 'agentWithdraw' not in(SELECT dict_code FROM  user_task_reminder WHERE dict_code='agentWithdraw');

INSERT INTO "user_task_reminder" ("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
SELECT 'rakeback', '2015-11-10 18:01:14', '0', '/operation/rakebackBill/list.html', 'examine', '返水结算审批', NULL, 'audit'
WHERE 'rakeback' not in(SELECT dict_code FROM  user_task_reminder WHERE dict_code='rakeback');

INSERT INTO "user_task_reminder" ("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
SELECT 'preferential', '2015-11-10 18:01:14', '0', '/operation/activity/list.html', 'examine', '优惠活动审批', NULL, 'audit'
WHERE 'preferential' not in(SELECT dict_code FROM  user_task_reminder WHERE dict_code='preferential');

INSERT INTO "user_task_reminder" ("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
SELECT 'oneSituation', '2015-12-28 09:54:48', '0', NULL, 'pay', '情况一', NULL, 'warm'
WHERE 'oneSituation' not in(SELECT dict_code FROM  user_task_reminder WHERE dict_code='oneSituation');

INSERT INTO "user_task_reminder" ("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
SELECT 'playerConsultation', '2016-01-17 01:17:24.117885', '0', '/operation/announcementMessage/advisoryMessage.html', 'consultation', '玩家咨询', NULL, 'notice'
WHERE 'playerConsultation' not in(SELECT dict_code FROM  user_task_reminder WHERE dict_code='playerConsultation');

INSERT INTO "user_task_reminder" ("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
SELECT 'playerWithdraw', '2016-01-15 07:05:52.542576', '0', '/fund/withdraw/withdrawList.html', 'examine', '玩家取款审批', NULL, 'draw'
WHERE 'playerWithdraw' not in(SELECT dict_code FROM  user_task_reminder WHERE dict_code='playerWithdraw');

INSERT INTO "user_task_reminder" ("dict_code", "update_time", "task_num", "task_url", "parent_code", "remark", "param_value", "tone_type")
SELECT 'recharge', '2016-01-15 07:06:20.77083', '0', '/fund/companyDespoit/list.html?search.rechargeStatus=1', 'examine', '存款审批', NULL, 'deposit'
WHERE 'recharge' not in(SELECT dict_code FROM  user_task_reminder WHERE dict_code='recharge');

update sys_user set subsys_code='mcenter' where id=0;
