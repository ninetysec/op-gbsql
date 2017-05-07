-- auto gen by orange 2016-03-02 15:28:41
delete from notice_tmpl where event_type = 'PREFERENCE_AUDIT_SUCCESS' and publish_method = 'siteMsg';

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
select   'auto', 'PREFERENCE_AUDIT_SUCCESS', 'siteMsg', '1441124613861-iopqwersae', 't', 'zh_CN', '您于${time}申领的“${name}”优惠活动，审核成功！', '尊敬的${user}，您好：
您于${time}申领的“${name}”优惠活动，已通过审核！优惠金额已发放至您的钱包，请注意查收！本邮件为系统自动发出，请勿直接回复！ GameBox    ${year}年${month}月${day}日', 't', 'title', 'content', '2015-10-14 16:39:11.174545', '1', NULL, NULL, 't'
where 'PREFERENCE_AUDIT_SUCCESS' not in (
			select event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_SUCCESS' and locale = 'zh_CN' and publish_method = 'siteMsg'
);
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
select   'auto', 'PREFERENCE_AUDIT_SUCCESS', 'siteMsg', '1441124613861-iopqwersae', 't', 'zh_TW', '您于${time}申领的“${name}”优惠活动，审核成功！', '尊敬的${user}，您好：
您于${time}申领的“${name}”优惠活动，已通过审核！优惠金额已发放至您的钱包，请注意查收！本邮件为系统自动发出，请勿直接回复！ GameBox    ${year}年${month}月${day}日', 't', 'title', 'content', '2015-10-14 16:39:11.174545', '1', NULL, NULL, 't'
where 'PREFERENCE_AUDIT_SUCCESS' not in (
			select event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_SUCCESS' and locale = 'zh_TW' and publish_method = 'siteMsg'
);
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
select   'auto', 'PREFERENCE_AUDIT_SUCCESS', 'siteMsg', '1441124613861-iopqwersae', 't', 'en_US', '您于${time}申领的“${name}”优惠活动，审核成功！', '尊敬的${user}，您好：
您于${time}申领的“${name}”优惠活动，已通过审核！优惠金额已发放至您的钱包，请注意查收！本邮件为系统自动发出，请勿直接回复！ GameBox    ${year}年${month}月${day}日', 't', 'title', 'content', '2015-10-14 16:39:11.174545', '1', NULL, NULL, 't'
where 'PREFERENCE_AUDIT_SUCCESS' not in (
			select event_type from notice_tmpl where event_type = 'PREFERENCE_AUDIT_SUCCESS' and locale = 'en_US' and publish_method = 'siteMsg'
);
--------玩家取款审核成功-------------
delete from notice_tmpl where event_type = 'PLAYER_WITHDRAWAL_AUDIT_SUCCESS' and publish_method = 'siteMsg';

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
select  'auto', 'PLAYER_WITHDRAWAL_AUDIT_SUCCESS', 'siteMsg', '2b801fbd304e00366393bdb9bf1d6c24', 't', 'en_US', '您于${time}申请的¥${plaseMoney}取款订单，审核成功！', '您于${time}申请的¥${plaseMoney}取款订单${order}，已通过审核！最终取款¥${withdrawMoney}，该笔金额稍后将转至您的${bank}账户（尾号${tailNumber}），请注意查收！如未到账，请联系客服处理。', 't', '', '', '2016-02-25 03:22:22.478277', '1', '2016-02-25 03:22:22.478277', '1', 't'
where 'PLAYER_WITHDRAWAL_AUDIT_SUCCESS' not in (
			select event_type from notice_tmpl where event_type = 'PLAYER_WITHDRAWAL_AUDIT_SUCCESS' and locale = 'en_US' and publish_method = 'siteMsg'
);
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
select  'auto', 'PLAYER_WITHDRAWAL_AUDIT_SUCCESS', 'siteMsg', '2b801fbd304e00366393bdb9bf1d6c24', 't', 'zh_CN', '您于${time}申请的¥${plaseMoney}取款订单，审核成功！', '您于${time}申请的¥${plaseMoney}取款订单${order}，已通过审核！最终取款¥${withdrawMoney}，该笔金额稍后将转至您的${bank}账户（尾号${tailNumber}），请注意查收！如未到账，请联系客服处理。', 't', '', '', '2016-02-25 03:22:22.478277', '1', '2016-02-25 03:22:22.478277', '1', 't'
where 'PLAYER_WITHDRAWAL_AUDIT_SUCCESS' not in (
			select event_type from notice_tmpl where event_type = 'PLAYER_WITHDRAWAL_AUDIT_SUCCESS' and locale = 'zh_CN' and publish_method = 'siteMsg'
);
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
select  'auto', 'PLAYER_WITHDRAWAL_AUDIT_SUCCESS', 'siteMsg', '2b801fbd304e00366393bdb9bf1d6c24', 't', 'zh_TW', '您于${time}申请的¥${plaseMoney}取款订单，审核成功！', '您于${time}申请的¥${plaseMoney}取款订单${order}，已通过审核！最终取款¥${withdrawMoney}，该笔金额稍后将转至您的${bank}账户（尾号${tailNumber}），请注意查收！如未到账，请联系客服处理。', 't', '', '', '2016-02-25 03:22:22.478277', '1', '2016-02-25 03:22:22.478277', '1', 't'
where 'PLAYER_WITHDRAWAL_AUDIT_SUCCESS' not in (
			select event_type from notice_tmpl where event_type = 'PLAYER_WITHDRAWAL_AUDIT_SUCCESS' and locale = 'zh_TW' and publish_method = 'siteMsg'
);

-----------代理取款审核成功------------

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
select  'auto', 'AGENT_WITHDRAWAL_AUDIT_SUCCESS', 'siteMsg', '2b801fbd304e00366393bdb9bf1d6c24', 't', 'en_US', '您于${time}申请的¥${plaseMoney}取款订单，审核成功！', '您于${time}申请的¥${plaseMoney}取款订单${order}，已通过审核！该笔佣金稍后将转至您的${bank}账户（尾号${tailNumber}），请注意查收！如未到账，请联系客服处理。', 't', '', '', '2016-02-25 03:22:22.478277', '1', '2016-02-25 03:22:22.478277', '1', 't'
where 'AGENT_WITHDRAWAL_AUDIT_SUCCESS' not in (
			select event_type from notice_tmpl where event_type = 'AGENT_WITHDRAWAL_AUDIT_SUCCESS' and locale = 'en_US' and publish_method = 'siteMsg'
);
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
select  'auto', 'AGENT_WITHDRAWAL_AUDIT_SUCCESS', 'siteMsg', '2b801fbd304e00366393bdb9bf1d6c24', 't', 'zh_CN', '您于${time}申请的¥${plaseMoney}取款订单，审核成功！', '您于${time}申请的¥${plaseMoney}取款订单${order}，已通过审核！该笔佣金稍后将转至您的${bank}账户（尾号${tailNumber}），请注意查收！如未到账，请联系客服处理。', 't', '', '', '2016-02-25 03:22:22.478277', '1', '2016-02-25 03:22:22.478277', '1', 't'
where 'AGENT_WITHDRAWAL_AUDIT_SUCCESS' not in (
			select event_type from notice_tmpl where event_type = 'AGENT_WITHDRAWAL_AUDIT_SUCCESS' and locale = 'zh_CN' and publish_method = 'siteMsg'
);
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
select  'auto', 'AGENT_WITHDRAWAL_AUDIT_SUCCESS', 'siteMsg', '2b801fbd304e00366393bdb9bf1d6c24', 't', 'zh_TW', '您于${time}申请的¥${plaseMoney}取款订单，审核成功！', '您于${time}申请的¥${plaseMoney}取款订单${order}，已通过审核！该笔佣金稍后将转至您的${bank}账户（尾号${tailNumber}），请注意查收！如未到账，请联系客服处理。', 't', '', '', '2016-02-25 03:22:22.478277', '1', '2016-02-25 03:22:22.478277', '1', 't'
where 'AGENT_WITHDRAWAL_AUDIT_SUCCESS' not in (
			select event_type from notice_tmpl where event_type = 'AGENT_WITHDRAWAL_AUDIT_SUCCESS' and locale = 'zh_TW' and publish_method = 'siteMsg'
);