-- auto gen by george 2018-01-02 09:16:50
INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content",
"default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'CREDIT_GET_QUOTA', 'siteMsg', '1881951512018-iolqawaeara', 't', 'zh_CN', '额度到账，请留意查收！', '站点于${充值时间}通过系统自助充值，已成功提升额度${充值额度}，请留意查收！',
't', 'title', 'content', '2018-01-01 09:07:53.995103', '1', NULL, NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM notice_tmpl WHERE group_code='1881951512018-iolqawaeara' AND locale='zh_CN');

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content",
"default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'CREDIT_GET_QUOTA', 'siteMsg', '1881951512018-iolqawaeara', 't', 'zh_TW', '额度到账，请留意查收！', '站点于${充值时间}通过系统自助充值，已成功提升额度${充值额度}，请留意查收！',
't', 'title', 'content', '2018-01-01 09:07:53.995103', '1', NULL, NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM notice_tmpl WHERE group_code='1881951512018-iolqawaeara' AND locale='zh_TW');

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content",
"default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'CREDIT_GET_QUOTA', 'siteMsg', '1881951512018-iolqawaeara', 't', 'ja_JP', '额度到账，请留意查收！', '站点于${充值时间}通过系统自助充值，已成功提升额度${充值额度}，请留意查收！',
't', 'title', 'content', '2018-01-01 09:07:53.995103', '1', NULL, NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM notice_tmpl WHERE group_code='1881951512018-iolqawaeara' AND locale='ja_JP');

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content",
"default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'CREDIT_GET_QUOTA', 'siteMsg', '1881951512018-iolqawaeara', 't', 'en_US', '额度到账，请留意查收！', '站点于${充值时间}通过系统自助充值，已成功提升额度${充值额度}，请留意查收！',
't', 'title', 'content', '2018-01-01 09:07:53.995103', '1', NULL, NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM notice_tmpl WHERE group_code='1881951512018-iolqawaeara' AND locale='en_US');

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content",
"default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'GET_CREDIT_LINE', 'siteMsg', '1881951512019-iolqawaeara', 't', 'en_US', '恭喜您，免费获得授信额度，请留意查收！', '系统于${授信时间}免费赠送您授信额度${授信额度}，请留意查收！',
't', 'title', 'content', '2018-01-01 09:07:53.995103', '1', NULL, NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM notice_tmpl WHERE group_code='1881951512019-iolqawaeara' AND locale='en_US');

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content",
"default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'GET_CREDIT_LINE', 'siteMsg', '1881951512019-iolqawaeara', 't', 'ja_JP', '恭喜您，免费获得授信额度，请留意查收！', '系统于${授信时间}免费赠送您授信额度${授信额度}，请留意查收！',
't', 'title', 'content', '2018-01-01 09:07:53.995103', '1', NULL, NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM notice_tmpl WHERE group_code='1881951512019-iolqawaeara' AND locale='ja_JP');

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content",
"default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'GET_CREDIT_LINE', 'siteMsg', '1881951512019-iolqawaeara', 't', 'zh_TW', '恭喜您，免费获得授信额度，请留意查收！', '系统于${授信时间}免费赠送您授信额度${授信额度}，请留意查收！',
't', 'title', 'content', '2018-01-01 09:07:53.995103', '1', NULL, NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM notice_tmpl WHERE group_code='1881951512019-iolqawaeara' AND locale='zh_TW');

INSERT INTO "notice_tmpl" ("tmpl_type", "event_type", "publish_method", "group_code", "active", "locale", "title", "content",
"default_active", "default_title", "default_content", "create_time", "create_user", "update_time", "update_user", "built_in")
SELECT 'auto', 'GET_CREDIT_LINE', 'siteMsg', '1881951512019-iolqawaeara', 't', 'zh_CN', '恭喜您，免费获得授信额度，请留意查收！', '系统于${授信时间}免费赠送您授信额度${授信额度}，请留意查收！',
't', 'title', 'content', '2018-01-01 09:07:53.995103', '1', NULL, NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM notice_tmpl WHERE group_code='1881951512019-iolqawaeara' AND locale='zh_CN');

