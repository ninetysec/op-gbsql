-- auto gen by longer 2016-01-17 10:38:52
truncate table user_task_reminder;

SELECT  redo_sqls($$
 alter table user_task_reminder rename account_oper_url TO param_value;
$$);


INSERT INTO user_task_reminder ( dict_code, update_time, task_num, task_url, parent_code, remark, param_value, tone_type) VALUES ( 'rebate', '2015-11-10 18:01:14.000000', 0, '/operation/rebate/list.html', 'examine', '返佣结算审批', null, 'audit');
INSERT INTO user_task_reminder ( dict_code, update_time, task_num, task_url, parent_code, remark, param_value, tone_type) VALUES ( 'orange', '2016-01-15 07:25:59.416017', 182, null, 'pay', '橙色预警', '{"payType":"company_deposit","toneType":"warm","taskCode":"orange","warningVal":"56","updateTime":1452842944942,"payId":522}', 'warm');
INSERT INTO user_task_reminder ( dict_code, update_time, task_num, task_url, parent_code, remark, param_value, tone_type) VALUES ( 'red', '2016-01-15 07:26:21.790209', 5, '', 'pay', '红色预警', '{"payType":"company_deposit","toneType":"warm","taskCode":"red","warningVal":"56","updateTime":1452842967315,"payId":522}', 'warm');
INSERT INTO user_task_reminder ( dict_code, update_time, task_num, task_url, parent_code, remark, param_value, tone_type) VALUES ( 'profitYellow', '2015-12-28 09:54:48.000000', 0, null, 'profit', '盈利黄色预警', '', '');
INSERT INTO user_task_reminder ( dict_code, update_time, task_num, task_url, parent_code, remark, param_value, tone_type) VALUES ( 'profitRed', '2015-12-28 09:54:48.000000', 0, null, 'profit', '盈利黄色预警', '', '');
INSERT INTO user_task_reminder ( dict_code, update_time, task_num, task_url, parent_code, remark, param_value, tone_type) VALUES ( 'station', '2015-11-10 18:01:14.000000', 0, null, 'bill', '站务账单', null, 'notice');
INSERT INTO user_task_reminder ( dict_code, update_time, task_num, task_url, parent_code, remark, param_value, tone_type) VALUES ( 'topAgentStation', '2015-11-10 18:01:14.000000', 0, null, 'bill', '总代账单', null, 'notice');
INSERT INTO user_task_reminder ( dict_code, update_time, task_num, task_url, parent_code, remark, param_value, tone_type) VALUES ( 'profitOrange', '2016-01-14 08:44:14.691942', 2, null, 'profit', '盈利橙色预警', '', '');
INSERT INTO user_task_reminder ( dict_code, update_time, task_num, task_url, parent_code, remark, param_value, tone_type) VALUES ( 'freeze', '2016-01-15 07:28:43.866631', 7, '', 'pay', '红色预警', '{"payType":"company_deposit","toneType":"warm","taskCode":"freeze","warningVal":"56","updateTime":1452843109398,"payId":522}', 'warm');
INSERT INTO user_task_reminder ( dict_code, update_time, task_num, task_url, parent_code, remark, param_value, tone_type) VALUES ( 'twoSituation', '2015-12-28 09:54:48.000000', 0, '', 'pay', '情况二', '{"hourNum":"3","payAccount":"****2","payName":"1"}', 'warm');
INSERT INTO user_task_reminder ( dict_code, update_time, task_num, task_url, parent_code, remark, param_value, tone_type) VALUES ( 'agentWithdraw', '2016-01-15 07:13:21.749553', 10, '/fund/vAgentWithdrawOrder/agentList.html', 'examine', '代理取款审批', null, 'draw');
INSERT INTO user_task_reminder ( dict_code, update_time, task_num, task_url, parent_code, remark, param_value, tone_type) VALUES ( 'rakeback', '2015-11-10 18:01:14.000000', 0, '/operation/rakebackBill/list.html', 'examine', '返水结算审批', null, 'audit');
INSERT INTO user_task_reminder ( dict_code, update_time, task_num, task_url, parent_code, remark, param_value, tone_type) VALUES ( 'preferential', '2015-11-10 18:01:14.000000', 0, '/operation/activity/list.html', 'examine', '优惠活动审批', null, 'audit');
INSERT INTO user_task_reminder ( dict_code, update_time, task_num, task_url, parent_code, remark, param_value, tone_type) VALUES ( 'oneSituation', '2015-12-28 09:54:48.000000', 0, null, 'pay', '情况一', '{"times":"5","hourNum":"3","payAccount":"****2","payName":"1","playerNum":"4"}', 'warm');
INSERT INTO user_task_reminder ( dict_code, update_time, task_num, task_url, parent_code, remark, param_value, tone_type) VALUES ( 'playerConsultation', '2016-01-17 01:17:24.117885', -5, '/operation/announcementMessage/advisoryMessage.html', 'consultation', '玩家咨询', '{"payType":"","toneType":"notice","taskCode":"playerConsultation"}', 'notice');
INSERT INTO user_task_reminder ( dict_code, update_time, task_num, task_url, parent_code, remark, param_value, tone_type) VALUES ( 'playerWithdraw', '2016-01-15 07:05:52.542576', 12, '/fund/withdraw/withdrawList.html', 'examine', '玩家取款审批', null, 'draw');
INSERT INTO user_task_reminder ( dict_code, update_time, task_num, task_url, parent_code, remark, param_value, tone_type) VALUES ( 'recharge', '2016-01-15 07:06:20.770830', -1, '/fund/companyDespoit/list.html?search.rechargeStatus=1', 'examine', '存款审批', null, 'deposit');
