-- auto gen by orange 2016-01-13 15:36:17
select redo_sqls($$
delete from notice_tmpl where event_type = 'WITHDRAWAL_AUDIT_FAIL';
delete from notice_tmpl where event_type = 'REFUSE_WITHDRAWAL';

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
 select 'manual', 'PLAYER_WITHDRAWAL_AUDIT_FAIL', 'siteMsg', '1441964613860-sqiuiuty', 't', 'zh_CN', 'title', 'content', 't', 'title', 'content', '2015-09-17 09:07:53.995103', '1', NULL, NULL, 't'
where 'PLAYER_WITHDRAWAL_AUDIT_FAIL' not in  (
		select event_type from notice_tmpl where event_type='PLAYER_WITHDRAWAL_AUDIT_FAIL' and default_active = TRUE and locale = 'zh_CN'
);
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
 select 'manual', 'PLAYER_WITHDRAWAL_AUDIT_FAIL', 'siteMsg', '1441964613860-sqiuiuty', 't', 'zh_CN', 'title', 'content', 't', 'title', 'content', '2015-09-17 09:07:53.995103', '1', NULL, NULL, 't'
where 'PLAYER_WITHDRAWAL_AUDIT_FAIL' not in  (
		select event_type from notice_tmpl where event_type='PLAYER_WITHDRAWAL_AUDIT_FAIL' and default_active = TRUE and locale = 'en_US'
);
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
 select 'manual', 'PLAYER_WITHDRAWAL_AUDIT_FAIL', 'siteMsg', '1441964613860-sqiuiuty', 't', 'zh_CN', 'title', 'content', 't', 'title', 'content', '2015-09-17 09:07:53.995103', '1', NULL, NULL, 't'
where 'PLAYER_WITHDRAWAL_AUDIT_FAIL' not in  (
		select event_type from notice_tmpl where event_type='PLAYER_WITHDRAWAL_AUDIT_FAIL' and default_active = TRUE and locale = 'zh_TW'
);



INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
 select 'manual', 'REFUSE_PLAYER_WITHDRAWAL', 'siteMsg', '1441964613860-sqiuiuty', 't', 'zh_CN', 'title', 'content', 't', 'title', 'content', '2015-09-17 09:07:53.995103', '1', NULL, NULL, 't'
where 'REFUSE_PLAYER_WITHDRAWAL' not in  (
		select event_type from notice_tmpl where event_type='REFUSE_PLAYER_WITHDRAWAL' and default_active = TRUE and locale = 'zh_CN'
);
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
 select 'manual', 'REFUSE_PLAYER_WITHDRAWAL', 'siteMsg', '1441964613860-sqiuiuty', 't', 'zh_CN', 'title', 'content', 't', 'title', 'content', '2015-09-17 09:07:53.995103', '1', NULL, NULL, 't'
where 'REFUSE_PLAYER_WITHDRAWAL' not in  (
		select event_type from notice_tmpl where event_type='REFUSE_PLAYER_WITHDRAWAL' and default_active = TRUE and locale = 'en_US'
);
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
 select 'manual', 'REFUSE_PLAYER_WITHDRAWAL', 'siteMsg', '1441964613860-sqiuiuty', 't', 'zh_CN', 'title', 'content', 't', 'title', 'content', '2015-09-17 09:07:53.995103', '1', NULL, NULL, 't'
where 'REFUSE_PLAYER_WITHDRAWAL' not in  (
		select event_type from notice_tmpl where event_type='REFUSE_PLAYER_WITHDRAWAL' and default_active = TRUE and locale = 'zh_TW'
);



INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
 select 'manual', 'AGENT_WITHDRAWAL_AUDIT_FAIL', 'siteMsg', '1441964613860-sqiuiuty', 't', 'zh_CN', 'title', 'content', 't', 'title', 'content', '2015-09-17 09:07:53.995103', '1', NULL, NULL, 't'
where 'AGENT_WITHDRAWAL_AUDIT_FAIL' not in  (
		select event_type from notice_tmpl where event_type='AGENT_WITHDRAWAL_AUDIT_FAIL' and default_active = TRUE and locale = 'zh_CN'
);
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
 select 'manual', 'AGENT_WITHDRAWAL_AUDIT_FAIL', 'siteMsg', '1441964613860-sqiuiuty', 't', 'zh_CN', 'title', 'content', 't', 'title', 'content', '2015-09-17 09:07:53.995103', '1', NULL, NULL, 't'
where 'AGENT_WITHDRAWAL_AUDIT_FAIL' not in  (
		select event_type from notice_tmpl where event_type='AGENT_WITHDRAWAL_AUDIT_FAIL' and default_active = TRUE and locale = 'en_US'
);
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
 select 'manual', 'AGENT_WITHDRAWAL_AUDIT_FAIL', 'siteMsg', '1441964613860-sqiuiuty', 't', 'zh_CN', 'title', 'content', 't', 'title', 'content', '2015-09-17 09:07:53.995103', '1', NULL, NULL, 't'
where 'AGENT_WITHDRAWAL_AUDIT_FAIL' not in  (
		select event_type from notice_tmpl where event_type='AGENT_WITHDRAWAL_AUDIT_FAIL' and default_active = TRUE and locale = 'zh_TW'
);


INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
 select 'manual', 'REFUSE_AGENT_WITHDRAWAL', 'siteMsg', '1441964613860-sqiuiuty', 't', 'zh_CN', 'title', 'content', 't', 'title', 'content', '2015-09-17 09:07:53.995103', '1', NULL, NULL, 't'
where 'REFUSE_AGENT_WITHDRAWAL' not in  (
		select event_type from notice_tmpl where event_type='REFUSE_AGENT_WITHDRAWAL' and default_active = TRUE and locale = 'zh_CN'
);
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
 select 'manual', 'REFUSE_AGENT_WITHDRAWAL', 'siteMsg', '1441964613860-sqiuiuty', 't', 'zh_CN', 'title', 'content', 't', 'title', 'content', '2015-09-17 09:07:53.995103', '1', NULL, NULL, 't'
where 'REFUSE_AGENT_WITHDRAWAL' not in  (
		select event_type from notice_tmpl where event_type='REFUSE_AGENT_WITHDRAWAL' and default_active = TRUE and locale = 'en_US'
);
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content", "default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
 select 'manual', 'REFUSE_AGENT_WITHDRAWAL', 'siteMsg', '1441964613860-sqiuiuty', 't', 'zh_CN', 'title', 'content', 't', 'title', 'content', '2015-09-17 09:07:53.995103', '1', NULL, NULL, 't'
where 'REFUSE_AGENT_WITHDRAWAL' not in  (
		select event_type from notice_tmpl where event_type='REFUSE_AGENT_WITHDRAWAL' and default_active = TRUE and locale = 'zh_TW'
);
$$);
