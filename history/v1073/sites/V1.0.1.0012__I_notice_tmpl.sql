-- auto gen by cherry 2016-02-18 10:04:59
INSERT INTO "notice_tmpl" (

	"tmpl_type",

	"event_type",

	"publish_method",

	"group_code",

	"active",

	"locale",

	"title",

	"content",

	"default_active",

	"default_title",

	"default_content",

	"create_time",

	"create_user",

	"built_in"

)SELECT

		'auto',

		'AGENT_REGISTER_SUCCESS',

		'email',

		'2744e8b83fd125c381bef3fc8d0898cd',

		't',

		'zh_TW',

		'代理注册成功',

		'代理注册成功',

		't',

		'代理注册成功',

		'代理注册成功',

		now(),

		'1',

		't'

WHERE (SELECT "count"(1) from notice_tmpl where event_type = 'AGENT_REGISTER_SUCCESS' AND locale = 'zh_TW') = 0;

INSERT INTO "notice_tmpl" (

	"tmpl_type",

	"event_type",

	"publish_method",

	"group_code",

	"active",

	"locale",

	"title",

	"content",

	"default_active",

	"default_title",

	"default_content",

	"create_time",

	"create_user",

	"built_in"

)SELECT

		'auto',

		'AGENT_REGISTER_SUCCESS',

		'email',

		'2744e8b83fd125c381bef3fc8d0898cd',

		't',

		'en_US',

		'代理注册成功',

		'代理注册成功',

		't',

		'代理注册成功',

		'代理注册成功',

		now(),

		'1',

		't'

WHERE (SELECT "count"(1) from notice_tmpl where event_type = 'AGENT_REGISTER_SUCCESS' AND locale = 'en_US') = 0;

INSERT INTO "notice_tmpl" (

	"tmpl_type",

	"event_type",

	"publish_method",

	"group_code",

	"active",

	"locale",

	"title",

	"content",

	"default_active",

	"default_title",

	"default_content",

	"create_time",

	"create_user",

	"built_in"

)SELECT

		'auto',

		'AGENT_REGISTER_SUCCESS',

		'email',

		'2744e8b83fd125c381bef3fc8d0898cd',

		't',

		'zh_CN',

		'代理注册成功',

		'代理注册成功',

		't',

		'代理注册成功',

		'代理注册成功',

		now(),

		'1',

		't'

WHERE (SELECT "count"(1) from notice_tmpl where event_type = 'AGENT_REGISTER_SUCCESS' AND locale = 'zh_CN') = 0;

INSERT INTO "notice_tmpl" (

	"tmpl_type",

	"event_type",

	"publish_method",

	"group_code",

	"active",

	"locale",

	"title",

	"content",

	"default_active",

	"default_title",

	"default_content",

	"create_time",

	"create_user",

	"built_in"

)

SELECT

		'auto',

		'PLAYER_REGISTER_SUCCESS',

		'email',

		'45872c3f0036c74280fd647c683899f1',

		't',

		'zh_TW',

		'玩家注册成功',

		'玩家注册成功',

		't',

		'玩家注册成功',

		'玩家注册成功',

		now(),

		'1',

		't'

WHERE (SELECT "count"(1) from notice_tmpl where event_type = 'PLAYER_REGISTER_SUCCESS' AND locale = 'zh_TW') = 0;

INSERT INTO "notice_tmpl" (

	"tmpl_type",

	"event_type",

	"publish_method",

	"group_code",

	"active",

	"locale",

	"title",

	"content",

	"default_active",

	"default_title",

	"default_content",

	"create_time",

	"create_user",

	"built_in"

)

SELECT

		'auto',

		'PLAYER_REGISTER_SUCCESS',

		'email',

		'45872c3f0036c74280fd647c683899f1',

		't',

		'zh_CN',

		'玩家注册成功',

		'玩家注册成功',

		't',

		'玩家注册成功',

		'玩家注册成功',

		now(),

		'1',

		't'

WHERE (SELECT "count"(1) from notice_tmpl where event_type = 'PLAYER_REGISTER_SUCCESS' AND locale = 'zh_CN') = 0;

INSERT INTO "notice_tmpl" (

	"tmpl_type",

	"event_type",

	"publish_method",

	"group_code",

	"active",

	"locale",

	"title",

	"content",

	"default_active",

	"default_title",

	"default_content",

	"create_time",

	"create_user",

	"built_in"

)

SELECT

		'auto',

		'PLAYER_REGISTER_SUCCESS',

		'email',

		'45872c3f0036c74280fd647c683899f1',

		't',

		'en_US',

		'玩家注册成功',

		'玩家注册成功',

		't',

		'玩家注册成功',

		'玩家注册成功',

		now(),

		'1',

		't'

WHERE (SELECT "count"(1) from notice_tmpl where event_type = 'PLAYER_REGISTER_SUCCESS' AND locale = 'en_US') = 0;

 select redo_sqls($$
        ALTER TABLE "user_bankcard" ADD COLUMN "is_auto_match" bool;
$$);

COMMENT ON COLUMN "user_bankcard"."is_auto_match" IS '是否自动根据银行卡号匹配银行';