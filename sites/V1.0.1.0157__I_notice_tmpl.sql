-- auto gen by admin 2016-05-25 19:24:14
--添加手动存款的模板
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
select 'auto', 'MANUAL_RECHARGE_SUCCESS', 'siteMsg', '1441934613861-iopqwere1', 't', 'en_US', 'The administrator has been deposited ¥${orderamount} for you, please note to check it.', 'The administrator has been deposited ¥${orderamount} into your account at ${orderlaunchtime}, please note to check it.', 't', 'The administrator has been deposited ¥${orderamount} for you, please note to check it.', 'The administrator has been deposited ¥${orderamount} into your account at ${orderlaunchtime}, please note to check it.', '2016-04-24 08:23:03.419482', '0', NULL, NULL, 't'
where  'MANUAL_RECHARGE_SUCCESS' not  in (select event_type from notice_tmpl where event_type='MANUAL_RECHARGE_SUCCESS' and locale='en_US' );

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
select  'auto', 'MANUAL_RECHARGE_SUCCESS', 'siteMsg', '1441934613861-iopqwere1', 't', 'zh_TW', '管理员已为您手动存款¥${orderamount}，请注意查收！', '管理员已于${orderlaunchtime}向您的账户存款¥${orderamount}，请注意查收！', 't', '管理员已为您手动存款¥${orderamount}，请注意查收！', '管理员已于${orderlaunchtime}向您的账户存款¥${orderamount}，请注意查收！', '2016-05-24 08:23:03', '0', NULL, NULL, 't'
where 'MANUAL_RECHARGE_SUCCESS' not  in (select event_type from notice_tmpl where event_type='MANUAL_RECHARGE_SUCCESS' and locale='zh_TW' );

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
select 'auto', 'MANUAL_RECHARGE_SUCCESS', 'siteMsg', '1441934613861-iopqwere1', 't', 'zh_CN', '管理员已为您手动存款¥${orderamount}，请注意查收！', '管理员已于${orderlaunchtime}向您的账户存款¥${orderamount}，请注意查收！', 't', '管理员已为您手动存款¥${orderamount}，请注意查收！', '管理员已于${orderlaunchtime}向您的账户存款¥${orderamount}，请注意查收！', '2016-05-24 08:23:03', '0', NULL, NULL, 't'
where 'MANUAL_RECHARGE_SUCCESS' not  in (select event_type from notice_tmpl where event_type='MANUAL_RECHARGE_SUCCESS' and locale='zh_CN' );

