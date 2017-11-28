-- auto gen by admin 2016-06-14 14:44:13
DELETE FROM sys_resource WHERE subsys_code = 'pcenter';

INSERT INTO sys_resource ("id", "name", url, remark, parent_id, "structure", sort_num, subsys_code, permission, resource_type, icon, built_in, privilege, status)
VALUES ('40', '首页', '', '首页', NULL, NULL, 0, 'pcenter', '', '2', 'home', TRUE, FALSE, TRUE);
-- 1.钱包转账
INSERT INTO sys_resource("id", "name", url, remark, parent_id, "structure", sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
SELECT 41, '钱包转账', 'fund/playerTransfer/transfers.html', '玩家中心-钱包转账', NULL, NULL, 1, 'pcenter', 'pcenter:transfers', 1, 'capital', TRUE, FALSE, TRUE
 WHERE 'fund/playerTransfer/transfers.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'fund/playerTransfer/transfers.html');
-- 2.存款专区
INSERT INTO sys_resource("id", "name", url, remark, parent_id, "structure", sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
SELECT 42, '存款专区', 'fund/playerRecharge/recharge.html', '玩家中心-存款专区', NULL, NULL,2, 'pcenter','pcenter:deposit', 1, 'capital', TRUE, FALSE, TRUE
 WHERE 'fund/playerRecharge/recharge.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'fund/playerRecharge/recharge.html');
-- 3.取款专区
INSERT INTO sys_resource("id", "name", url, remark, parent_id, "structure", sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
SELECT 43, '取款专区','player/withdraw/withdrawList.html','玩家中心-取款专区', NULL, NULL, 3, 'pcenter', 'pcenter:withdraw', 1 ,'capital', TRUE, FALSE, TRUE
 WHERE 'player/withdraw/withdrawList.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'player/withdraw/withdrawList.html');
-- 4.资金记录
INSERT INTO sys_resource("id", "name", url, remark, parent_id, "structure", sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
SELECT 44, '资金记录', 'fund/transaction/list.html', '玩家中心-资金记录', NULL, NULL, 4, 'pcenter', 'pcenter:fundrecord', 1, 'capital', TRUE, FALSE, TRUE
 WHERE 'fund/transaction/list.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'fund/transaction/list.html');
-- 5.投注记录
INSERT INTO sys_resource("id", "name", url, remark, parent_id, "structure", sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
SELECT 45, '投注记录', 'vPlayerGameOrder/apiList.html?type=history', '玩家中心-投注记录', NULL, NULL,5, 'pcenter', 'pcenter:betorder', 1, 'gamerecord', TRUE, FALSE, TRUE
 WHERE 'vPlayerGameOrder/apiList.html?type=history' NOT IN (SELECT url FROM sys_resource WHERE url = 'vPlayerGameOrder/apiList.html?type=history');
-- 6.优惠记录
INSERT INTO sys_resource("id", "name", url, remark, parent_id, "structure", sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
SELECT 46, '优惠记录', 'preferential/list.html', '玩家中心-优惠记录', NULL, NULL, 6, 'pcenter', 'pcenter:preferential', 1, 'sale', TRUE, FALSE, TRUE
 WHERE 'preferential/list.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'preferential/list.html');
-- 7.消息公告
INSERT INTO sys_resource("id", "name", url, remark, parent_id, "structure", sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
SELECT 47, '消息公告', 'operation/pAnnouncementMessage/gameNotice.html', '玩家中心-消息公告', NULL, NULL, 7, 'pcenter','pcenter:announcement', 1, 'info', TRUE, FALSE, TRUE
 WHERE 'operation/pAnnouncementMessage/gameNotice.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'operation/pAnnouncementMessage/gameNotice.html');
-- 8.个人资料
INSERT INTO sys_resource("id", "name", url, remark, parent_id, "structure", sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
SELECT 48, '个人资料', 'personalInfo/view.html', '玩家中心-个人资料', NULL, NULL, 8, 'pcenter', 'pcenter:account', 1, 'accout', TRUE, FALSE, TRUE
 WHERE 'personalInfo/view.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'personalInfo/view.html');
-- 9.推荐好友
INSERT INTO sys_resource("id", "name", url, remark, parent_id, "structure", sort_num, subsys_code, permission, resource_type, icon, built_in, privilege,status)
SELECT 49, '推荐好友', 'playerRecommendAward/recommend.html', '玩家中心-推荐好友', NULL, NULL, 9, 'pcenter', 'pcenter:recommend', 1, 'recommend', TRUE, FALSE, TRUE
 WHERE 'playerRecommendAward/recommend.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'playerRecommendAward/recommend.html');
-- 确认取款
INSERT INTO sys_resource ("id", "name", url, remark, parent_id, "structure", sort_num, subsys_code, permission, resource_type, icon, built_in, privilege, status)
SELECT 4301, '确认取款', 'player/withdraw/pleaseWithdraw.html', '确认取款', 43, NULL, 1, 'pcenter', 'fund:deposit_confirm', 2, '', TRUE, TRUE, TRUE
 WHERE 'player/withdraw/pleaseWithdraw.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'player/withdraw/pleaseWithdraw.html');
-- 编辑玩家信息
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, built_in, privilege, status)
SELECT 4801, '编辑玩家信息', 'personalInfo/edit.html', '编辑玩家信息', 48, NULL, 1, 'pcenter', 'account:edit', 2, '', TRUE, TRUE, TRUE
 WHERE 'personalInfo/edit.html' NOT IN (SELECT url FROM sys_resource WHERE url = 'personalInfo/edit.html');

 UPDATE  "sys_resource" SET   "name"='个人资料', "url"='personInfo/index.html', "remark"='玩家中心-个人资料', "parent_id"=NULL, "structure"=NULL, "sort_num"='8', "subsys_code"='pcenter', "permission"='pcenter:account', "resource_type"='1', "icon"='accout', "built_in"='t', "privilege"='f', "status"='t' WHERE ("id"='48');

 SELECT redo_sqls($$
 	ALTER TABLE pay_account ADD COLUMN qr_code_url CHARACTER VARYING(200) NULL;
 $$);
 COMMENT ON COLUMN pay_account.qr_code_url is '第三方入款账户二维码图片路径';


DELETE from notice_tmpl where event_type='AGENT_WITHDRAWAL_AUDIT_FAIL' and group_code='1441964613860-sqiuiuty';

INSERT INTO "notice_tmpl" ( "tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in") VALUES ( 'manual', 'AGENT_WITHDRAWAL_AUDIT_FAIL', 'email', '1441964613860-sqiuiuty', 't', 'zh_TW', '您于${orderlaunchtime}申请的${orderamount}取款订单，取款失败！', '<p>

    &nbsp; &nbsp;尊敬的${user}，您好：

</p>

<p>

    &nbsp; &nbsp;您于${orderlaunchtime}申请的${orderamount}取款订单${ordernum}未通过管理员的审核，取款失败！该笔金额已返还至您的钱包，请查收！如有疑问，请${customer}处理！

</p>

<p>

    本邮件为系统自动发出，请勿直接回复！

</p>

<p>

    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${sitename}

</p>

<p>

    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${year}年${month}月${day}日

</p>', 't', '您于${orderlaunchtime}申请的${orderamount}取款订单，取款失败！', '<p>

    &nbsp; &nbsp;尊敬的${user}，您好：

</p>

<p>

    &nbsp; &nbsp;您于${orderlaunchtime}申请的${orderamount}取款订单${ordernum}未通过管理员的审核，取款失败！该笔金额已返还至您的钱包，请查收！如有疑问，请${customer}处理！

</p>

<p>

    本邮件为系统自动发出，请勿直接回复！

</p>

<p>

    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${sitename}

</p>

<p>

    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${year}年${month}月${day}日

</p>', '2016-04-22 08:23:03.419482', '0', NULL, NULL, 't');

INSERT INTO "notice_tmpl" ( "tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in") VALUES ( 'manual', 'AGENT_WITHDRAWAL_AUDIT_FAIL', 'email', '1441964613860-sqiuiuty', 't', 'en_US', '您于${orderlaunchtime}申请的${orderamount}取款订单，取款失败！', '<p>

    &nbsp; &nbsp;尊敬的${user}，您好：

</p>

<p>

    &nbsp; &nbsp;您于${orderlaunchtime}申请的${orderamount}取款订单${ordernum}未通过管理员的审核，取款失败！该笔金额已返还至您的钱包，请查收！如有疑问，请${customer}处理！

</p>

<p>

    本邮件为系统自动发出，请勿直接回复！

</p>

<p>

    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${sitename}

</p>

<p>

    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${year}年${month}月${day}日

</p>', 't', '您于${orderlaunchtime}申请的${orderamount}取款订单，取款失败！', '<p>

    &nbsp; &nbsp;尊敬的${user}，您好：

</p>

<p>

    &nbsp; &nbsp;您于${orderlaunchtime}申请的${orderamount}取款订单${ordernum}未通过管理员的审核，取款失败！该笔金额已返还至您的钱包，请查收！如有疑问，请${customer}处理！

</p>

<p>

    本邮件为系统自动发出，请勿直接回复！

</p>

<p>

    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${sitename}

</p>

<p>

    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${year}年${month}月${day}日

</p>', '2016-04-22 08:23:03.419482', '0', NULL, NULL, 't');

INSERT INTO "notice_tmpl" ( "tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in") VALUES ( 'manual', 'AGENT_WITHDRAWAL_AUDIT_FAIL', 'email', '1441964613860-sqiuiuty', 't', 'zh_CN', '您于${orderlaunchtime}申请的${orderamount}取款订单，取款失败！', '<p>

    &nbsp; &nbsp;尊敬的${user}，您好：

</p>

<p>

    &nbsp; &nbsp;您于${orderlaunchtime}申请的${orderamount}取款订单${ordernum}未通过管理员的审核，取款失败！该笔金额已返还至您的钱包，请查收！如有疑问，请${customer}处理！

</p>

<p>

    本邮件为系统自动发出，请勿直接回复！

</p>

<p>

    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${sitename}

</p>

<p>

    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${year}年${month}月${day}日

</p>', 't', '您于${orderlaunchtime}申请的${orderamount}取款订单，取款失败！', '<p>

    &nbsp; &nbsp;尊敬的${user}，您好：

</p>

<p>

    &nbsp; &nbsp;您于${orderlaunchtime}申请的${orderamount}取款订单${ordernum}未通过管理员的审核，取款失败！该笔金额已返还至您的钱包，请查收！如有疑问，请${customer}处理！

</p>

<p>

    本邮件为系统自动发出，请勿直接回复！

</p>

<p>

    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${sitename}

</p>

<p>

    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;${year}年${month}月${day}日

</p>', '2016-04-22 08:23:03.419482', '0', NULL, NULL, 't');

INSERT INTO "notice_tmpl" ( "tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in") VALUES ( 'manual', 'AGENT_WITHDRAWAL_AUDIT_FAIL', 'siteMsg', '1441964613860-sqiuiuty', 't', 'zh_TW', '您于${orderlaunchtime}申请的${orderamount}取款订单，取款失败！', '您于${orderlaunchtime}申请的${orderamount}取款订单${ordernum}未通过管理员的审核，取款失败！该笔金额已返还至您的钱包，请查收！如有疑问，请${customer}处理！', 't', '您于${orderlaunchtime}申请的${orderamount}取款订单，取款失败！', '您于${orderlaunchtime}申请的${orderamount}取款订单${ordernum}未通过管理员的审核，取款失败！该笔金额已返还至您的钱包，请查收！如有疑问，请${customer}处理！', '2016-04-22 08:23:03.419482', '0', NULL, NULL, 't');

INSERT INTO "notice_tmpl" ( "tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in") VALUES ( 'manual', 'AGENT_WITHDRAWAL_AUDIT_FAIL', 'siteMsg', '1441964613860-sqiuiuty', 't', 'zh_CN', '您于${orderlaunchtime}申请的${orderamount}取款订单，取款失败！', '您于${orderlaunchtime}申请的${orderamount}取款订单${ordernum}未通过管理员的审核，取款失败！该笔金额已返还至您的钱包，请查收！如有疑问，请${customer}处理！', 't', '您于${orderlaunchtime}申请的${orderamount}取款订单，取款失败！', '您于${orderlaunchtime}申请的${orderamount}取款订单${ordernum}未通过管理员的审核，取款失败！该笔金额已返还至您的钱包，请查收！如有疑问，请${customer}处理！', '2016-04-22 08:23:03.419482', '0', NULL, NULL, 't');

INSERT INTO "notice_tmpl" ( "tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in") VALUES ( 'manual', 'AGENT_WITHDRAWAL_AUDIT_FAIL', 'siteMsg', '1441964613860-sqiuiuty', 't', 'en_US', '您于${orderlaunchtime}申请的${orderamount}取款订单，取款失败！', '您于${orderlaunchtime}申请的${orderamount}取款订单${ordernum}未通过管理员的审核，取款失败！该笔金额已返还至您的钱包，请查收！如有疑问，请${customer}处理！', 't', '您于${orderlaunchtime}申请的${orderamount}取款订单，取款失败！', '您于${orderlaunchtime}申请的${orderamount}取款订单${ordernum}未通过管理员的审核，取款失败！该笔金额已返还至您的钱包，请查收！如有疑问，请${customer}处理！', '2016-04-22 08:23:03.419482', '0', NULL, NULL, 't');