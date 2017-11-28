-- auto gen by jeff 2016-01-31 09:47:01
-- 找回密码邮件密码
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
	"update_time",
	"update_user",
	"built_in"
)
select
		'auto',
		'BIND_EMAIL_VERIFICATION_CODE',
		'email',
		'f223628efe1084428038a8a7d029e9f1',
		't',
		'zh_CN',
		'找回密码',
		'<p>验证码:${verificationCode}</p>',
		't',
		'找回密码',
		'验证码:${verificationCode}',
		'2015-09-18 14:39:23.462204',
		'1',
		NULL,
		NULL,
		't'
WHERE (SELECT  count(1) FROM notice_tmpl where event_type ='BIND_EMAIL_VERIFICATION_CODE' AND locale = 'zh_CN') = 0 ;

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
	"update_time",
	"update_user",
	"built_in"
)
SELECT

		'auto',
		'BIND_EMAIL_VERIFICATION_CODE',
		'email',
		'f223628efe1084428038a8a7d029e9f1',
		't',
		'zh_TW',
		'找回密码',
		'<p>验证码:${verificationCode}</p>',
		't',
		'找回密码',
		'验证码:${verificationCode}',
		'2015-09-18 14:39:23.462204',
		'1',
		NULL,
		NULL,
		't'
	where (SELECT  count(1) FROM notice_tmpl where event_type ='BIND_EMAIL_VERIFICATION_CODE' AND locale = 'zh_TW') = 0 ;

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
	"update_time",
	"update_user",
	"built_in"
)
SELECT
		'auto',
		'BIND_EMAIL_VERIFICATION_CODE',
		'email',
		'f223628efe1084428038a8a7d029e9f1',
		't',
		'en_US',
		'找回密码',
		'<p>验证码:${verificationCode}</p>',
		't',
		'找回密码',
		'验证码:${verificationCode}',
		'2015-09-18 14:39:23.462204',
		'1',
		NULL,
		NULL,
		't'
where (SELECT  count(1) FROM notice_tmpl where event_type ='BIND_EMAIL_VERIFICATION_CODE' AND locale = 'en_US') = 0

