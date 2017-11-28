-- auto gen by orange 2016-02-28 11:40:16
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
select  'manual', 'CHANGE_PLAYER_DATA', 'siteMsg', 'adsfasdf', 't', 'zh_TW', '您的真实姓名已被管理员修改，请及时确认！', '管理员在后台修改了您的真实姓名，请及时确认！若非您主动申请修改，请及时联系客服处理！', 't', '您的真实姓名已被管理员修改，请及时确认！', '管理员在后台修改了您的真实姓名，请及时确认！若非您主动申请修改，请及时联系客服处理！', '2016-02-28 10:49:12', '2016', NULL, NULL, 't'
where 'CHANGE_PLAYER_DATA' not in (select event_type from notice_tmpl where event_type = 'CHANGE_PLAYER_DATA' and locale = 'zh_TW' and publish_method = 'siteMsg')
;
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
select  'manual', 'CHANGE_PLAYER_DATA', 'siteMsg', 'adsfasdf', 't', 'zh_CN', '您的真实姓名已被管理员修改，请及时确认！', '管理员在后台修改了您的真实姓名，请及时确认！若非您主动申请修改，请及时联系客服处理！', 't', '您的真实姓名已被管理员修改，请及时确认！', '管理员在后台修改了您的真实姓名，请及时确认！若非您主动申请修改，请及时联系客服处理！', '2016-02-28 10:49:12', '2016', NULL, NULL, 't'
where 'CHANGE_PLAYER_DATA' not in (select event_type from notice_tmpl where event_type = 'CHANGE_PLAYER_DATA' and locale = 'zh_CN' and publish_method = 'siteMsg')
;
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
select  'manual', 'CHANGE_PLAYER_DATA', 'siteMsg', 'adsfasdf', 't', 'zh_US', 'The administrator has been changed your real name, please confirm it in time.', 'Dear User, Hello,
the administrator has been changed your real name by the background, please confirm it in time. If it isn’t you initiative apply for change, please contact us.', 't', 'The administrator has been changed your real name, please confirm it in time.', 'Dear User, Hello,
the administrator has been changed your real name by the background, please confirm it in time. If it isn’t you initiative apply for change, please contact us.', '2016-02-28 10:49:12', '2016', NULL, NULL, 't'
where 'CHANGE_PLAYER_DATA' not in (select event_type from notice_tmpl where event_type = 'CHANGE_PLAYER_DATA' and locale = 'zh_US' and publish_method = 'siteMsg')
;

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
select  'manual', 'CHANGE_PLAYER_DATA', 'email', 'adsfasdf', 't', 'zh_TW', '您的真实姓名已被管理员修改，请及时确认！', '尊敬的user，您好：
管理员于2015-03-24 15:02:57通过后台操作修改了您的真实姓名，请及时确认。若非您主动申请修改，请及时联系客服处理！
本邮件为系统自动发出，请勿直接回复！ ', 't', '您的真实姓名已被管理员修改，请及时确认！', '尊敬的user，您好：
管理员于2015-03-24 15:02:57通过后台操作修改了您的真实姓名，请及时确认。若非您主动申请修改，请及时联系客服处理！
本邮件为系统自动发出，请勿直接回复！ ', '2016-02-28 10:49:12', '2016', NULL, NULL, 't'
where 'CHANGE_PLAYER_DATA' not in (select event_type from notice_tmpl where event_type = 'CHANGE_PLAYER_DATA' and locale = 'zh_TW' and publish_method = 'email')
;
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
select  'manual', 'CHANGE_PLAYER_DATA', 'email', 'adsfasdf', 't', 'zh_CN', '您的真实姓名已被管理员修改，请及时确认！', '尊敬的user，您好：
管理员于2015-03-24 15:02:57通过后台操作修改了您的真实姓名，请及时确认。若非您主动申请修改，请及时联系客服处理！
本邮件为系统自动发出，请勿直接回复！ ', 't', '您的真实姓名已被管理员修改，请及时确认！', '尊敬的user，您好：
管理员于2015-03-24 15:02:57通过后台操作修改了您的真实姓名，请及时确认。若非您主动申请修改，请及时联系客服处理！
本邮件为系统自动发出，请勿直接回复！ ', '2016-02-28 10:49:12', '2016', NULL, NULL, 't'
where 'CHANGE_PLAYER_DATA' not in (select event_type from notice_tmpl where event_type = 'CHANGE_PLAYER_DATA' and locale = 'zh_CN' and publish_method = 'email')
;
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
select  'manual', 'CHANGE_PLAYER_DATA', 'email', 'adsfasdf', 't', 'zh_US', 'The administrator has been changed your real name, please confirm it in time.', 'Dear User,
Hello, the administrator has been changed your real name by the background at 3:02:57pm on Mar 24th, 2015, please confirm it in time. If it isn’t you initiative apply for change, please contact us.
This mail is sent from system automatically, please don’t reply directly. ', 't', 'The administrator has been changed your real name, please confirm it in time.', 'Dear User,
Hello, the administrator has been changed your real name by the background at 3:02:57pm on Mar 24th, 2015, please confirm it in time. If it isn’t you initiative apply for change, please contact us.
This mail is sent from system automatically, please don’t reply directly. ', '2016-02-28 10:49:12', '2016', NULL, NULL, 't'
where 'CHANGE_PLAYER_DATA' not in (select event_type from notice_tmpl where event_type = 'CHANGE_PLAYER_DATA' and locale = 'zh_US' and publish_method = 'email')
;


