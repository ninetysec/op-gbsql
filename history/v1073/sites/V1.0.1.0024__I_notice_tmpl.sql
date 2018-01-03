-- auto gen by cherry 2016-03-02 10:36:45
-- 代理注册成功信息模版
INSERT INTO  "notice_tmpl" ("tmpl_type","event_type",	"publish_method",	"group_code",	"active",	"locale",	"title",	"content",	"default_active",	"default_title",	"default_content",	"create_time",	"create_user",	"update_time",	"update_user",	"built_in")
SELECT	'auto',	'AGENT_REGISTER_SUCCESS',	'siteMsg',	'2b801fbd304e33346393bdb9bf1d334',	't',	'en_US',	'代理注册成功',	'代理注册成功',	't',	'代理注册成功',	'代理注册成功',	'2016-02-25 03:22:22.478277',	'1',	'2016-02-25 03:22:22.478277',	'1',	't'
WHERE	'AGENT_REGISTER_SUCCESS' NOT IN (	SELECT	event_type	FROM	notice_tmpl	WHERE	event_type = 'AGENT_REGISTER_SUCCESS'	AND locale = 'en_US'AND publish_method = 'siteMsg');

INSERT INTO  "notice_tmpl" ("tmpl_type","event_type",	"publish_method",	"group_code",	"active",	"locale",	"title",	"content",	"default_active",	"default_title",	"default_content",	"create_time",	"create_user",	"update_time",	"update_user",	"built_in")
SELECT	'auto',	'AGENT_REGISTER_SUCCESS',	'siteMsg',	'2b801fbd304e33346393bdb9bf1d334',	't',	'zh_CN',	'代理注册成功',	'代理注册成功',	't',	'代理注册成功',	'代理注册成功',	'2016-02-25 03:22:22.478277',	'1',	'2016-02-25 03:22:22.478277',	'1',	't'
WHERE	'AGENT_REGISTER_SUCCESS' NOT IN (	SELECT	event_type	FROM	notice_tmpl	WHERE	event_type = 'AGENT_REGISTER_SUCCESS'	AND locale = 'zh_CN'AND publish_method = 'siteMsg');

INSERT INTO "notice_tmpl" ("tmpl_type","event_type",	"publish_method",	"group_code",	"active",	"locale",	"title",	"content",	"default_active",	"default_title",	"default_content",	"create_time",	"create_user",	"update_time",	"update_user",	"built_in")
SELECT	'auto',	'AGENT_REGISTER_SUCCESS',	'siteMsg',	'2b801fbd304e33346393bdb9bf1d334',	't',	'zh_TW',	'代理注册成功',	'代理注册成功',	't',	'代理注册成功',	'代理注册成功',	'2016-02-25 03:22:22.478277',	'1',	'2016-02-25 03:22:22.478277',	'1',	't'
WHERE	'AGENT_REGISTER_SUCCESS' NOT IN (	SELECT	event_type	FROM	notice_tmpl	WHERE	event_type = 'AGENT_REGISTER_SUCCESS'	AND locale = 'zh_TW'AND publish_method = 'siteMsg');

--玩家注册成功信息模版
INSERT INTO "notice_tmpl" ("tmpl_type","event_type",	"publish_method",	"group_code",	"active",	"locale",	"title",	"content",	"default_active",	"default_title",	"default_content",	"create_time",	"create_user",	"update_time",	"update_user",	"built_in")
SELECT	'auto',	'PLAYER_REGISTER_SUCCESS',	'siteMsg',	'45872c3f0036c74280fd647c68389344',	't',	'en_US',	'玩家注册成功',	'玩家注册成功',	't',	'玩家注册成功',	'玩家注册成功',	'2016-02-25 03:22:22.478277',	'1',	'2016-02-25 03:22:22.478277',	'1',	't'
WHERE	'PLAYER_REGISTER_SUCCESS' NOT IN (	SELECT	event_type	FROM	notice_tmpl	WHERE	event_type = 'PLAYER_REGISTER_SUCCESS'	AND locale = 'en_US'AND publish_method = 'siteMsg');

INSERT INTO "notice_tmpl" ("tmpl_type","event_type",	"publish_method",	"group_code",	"active",	"locale",	"title",	"content",	"default_active",	"default_title",	"default_content",	"create_time",	"create_user",	"update_time",	"update_user",	"built_in")
SELECT	'auto',	'PLAYER_REGISTER_SUCCESS',	'siteMsg',	'45872c3f0036c74280fd647c68389344',	't',	'zh_CN',	'玩家注册成功',	'玩家注册成功',	't',	'玩家注册成功',	'玩家注册成功',	'2016-02-25 03:22:22.478277',	'1',	'2016-02-25 03:22:22.478277',	'1',	't'
WHERE	'PLAYER_REGISTER_SUCCESS' NOT IN (	SELECT	event_type	FROM	notice_tmpl	WHERE	event_type = 'PLAYER_REGISTER_SUCCESS'	AND locale = 'zh_CN'AND publish_method = 'siteMsg');

INSERT INTO  "notice_tmpl" ("tmpl_type","event_type",	"publish_method",	"group_code",	"active",	"locale",	"title",	"content",	"default_active",	"default_title",	"default_content",	"create_time",	"create_user",	"update_time",	"update_user",	"built_in")
SELECT	'auto',	'PLAYER_REGISTER_SUCCESS',	'siteMsg',	'45872c3f0036c74280fd647c68389344',	't',	'zh_TW',	'玩家注册成功',	'玩家注册成功',	't',	'玩家注册成功',	'玩家注册成功',	'2016-02-25 03:22:22.478277',	'1',	'2016-02-25 03:22:22.478277',	'1',	't'
WHERE	'PLAYER_REGISTER_SUCCESS' NOT IN (	SELECT	event_type	FROM	notice_tmpl	WHERE	event_type = 'PLAYER_REGISTER_SUCCESS'	AND locale = 'zh_TW'AND publish_method = 'siteMsg');



