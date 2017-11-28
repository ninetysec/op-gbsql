-- auto gen by cherry 2016-01-19 10:45:42
 INSERT INTO "notice_tmpl" ("tmpl_type","event_type","publish_method","group_code",	"active","locale","title","content","default_active",	"default_title","default_content","create_time","create_user",	"update_time","update_user",	"built_in")
SELECT 	'manual','PROFIT_MAX_YELLOW',	'siteMsg','1452751825160',	't','zh_CN','站长${userName}的站点“${siteName}”盈利上限已使用${rate}%！','站长${userName}的站点“${siteName}”盈利上限已使用${rate}%！该站点目前盈利上限${maxProfit}，当前盈利${rofit}！${view}','t','title','content','2015-11-12 08:30:54.267665',	'1',NULL,NULL,'t'
WHERE 'PROFIT_MAX_YELLOW' NOT in(SELECT event_type from notice_tmpl WHERE tmpl_type='manual' AND publish_method='siteMsg' AND locale='zh_CN');

INSERT INTO "notice_tmpl" ( "tmpl_type", "event_type", "publish_method", 	"group_code", "active", "locale", "title", "content", "default_active","default_title", 	"default_content",	"create_time", "create_user", 	"update_time", "update_user","built_in")
SELECT  	'manual', 'PROFIT_MAX_YELLOW', 'siteMsg', '1452751825160', 	't', 'en_US', '站长${userName}的站点“${siteName}”盈利上限已使用${rate}%！','站长${userName}的站点“${siteName}”盈利上限已使用${rate}%！该站点目前盈利上限${maxProfit}，当前盈利${rofit}！${view}',	't','title','content','2015-11-12 08:30:54.267665','1',NULL,NULL,'t'
WHERE 'PROFIT_MAX_YELLOW' NOT in(SELECT event_type from notice_tmpl WHERE tmpl_type='manual' AND publish_method='siteMsg' AND locale='en_US');

INSERT INTO "notice_tmpl" ("tmpl_type","event_type","publish_method","group_code",	"active","locale","title","content","default_active",	"default_title","default_content","create_time","create_user",	"update_time","update_user",	"built_in")
SELECT
		'manual',
		'PROFIT_MAX_YELLOW',
		'siteMsg',
		'1452751825160',
		't',
		'zh_TW',
		'站长${userName}的站点“${siteName}”盈利上限已使用${rate}%！',
		'站长${userName}的站点“${siteName}”盈利上限已使用${rate}%！该站点目前盈利上限${maxProfit}，当前盈利${rofit}！${view}',
		't',
		'title',
		'content',
		'2015-11-12 08:30:54.267665',
		'1',
		NULL,
		NULL,
		't'
WHERE 'PROFIT_MAX_YELLOW' NOT in(SELECT event_type from notice_tmpl WHERE tmpl_type='manual' AND publish_method='siteMsg' AND locale='zh_TW');

INSERT INTO "notice_tmpl" ("tmpl_type","event_type","publish_method","group_code",	"active","locale","title","content","default_active",	"default_title","default_content","create_time","create_user",	"update_time","update_user",	"built_in")
SELECT
		'manual',
		'PROFIT_MAX_ORANGE',
		'siteMsg',
		'1452751825161',
		't',
		'zh_CN',
		'站长${userName}的站点“${siteName}”盈利上限已使用${rate}%，很快将达到100%，请及时关注！',
		'站长${userName}的站点“${siteName}”盈利上限已使用${rate}%，很快将达到100%，请及时关注！该站点目前盈利上限${maxProfit}，当前盈利${rofit}！${view}',
		't',
		'title',
		'content',
		'2015-11-12 08:30:54.267665',
		'1',
		NULL,
		NULL,
		't'
WHERE 'PROFIT_MAX_ORANGE' NOT in(SELECT event_type from notice_tmpl WHERE tmpl_type='manual' AND publish_method='siteMsg' AND locale='zh_CN');

INSERT INTO "notice_tmpl" ("tmpl_type","event_type","publish_method","group_code",	"active","locale","title","content","default_active",	"default_title","default_content","create_time","create_user",	"update_time","update_user",	"built_in")
SELECT
		'manual',
		'PROFIT_MAX_ORANGE',
		'siteMsg',
		'1452751825161',
		't',
		'en_US',
		'站长${userName}的站点“${siteName}”盈利上限已使用${rate}%，很快将达到100%，请及时关注！',
		'站长${userName}的站点“${siteName}”盈利上限已使用${rate}%，很快将达到100%，请及时关注！该站点目前盈利上限${maxProfit}，当前盈利${rofit}！${view}',
		't',
		'title',
		'content',
		'2015-11-12 08:30:54.267665',
		'1',
		NULL,
		NULL,
		't'
WHERE 'PROFIT_MAX_ORANGE' NOT in(SELECT event_type from notice_tmpl WHERE tmpl_type='manual' AND publish_method='siteMsg' AND locale='en_US');

INSERT INTO "notice_tmpl" ("tmpl_type","event_type","publish_method","group_code",	"active","locale","title","content","default_active",	"default_title","default_content","create_time","create_user",	"update_time","update_user",	"built_in")
SELECT
		'manual',
		'PROFIT_MAX_ORANGE',
		'siteMsg',
		'1452751825161',
		't',
		'zh_TW',
		'站长${userName}的站点“${siteName}”盈利上限已使用${rate}%，很快将达到100%，请及时关注！',
		'站长${userName}的站点“${siteName}”盈利上限已使用${rate}%，很快将达到100%，请及时关注！该站点目前盈利上限${maxProfit}，当前盈利${rofit}！${view}',
		't',
		'title',
		'content',
		'2015-11-12 08:30:54.267665',
		'1',
		NULL,
		NULL,
		't'
WHERE 'PROFIT_MAX_ORANGE' NOT in(SELECT event_type from notice_tmpl WHERE tmpl_type='manual' AND publish_method='siteMsg' AND locale='zh_TW');

INSERT INTO "notice_tmpl" ("tmpl_type","event_type","publish_method","group_code",	"active","locale","title","content","default_active",	"default_title","default_content","create_time","create_user",	"update_time","update_user",	"built_in")
SELECT
		'manual',
		'PROFIT_MAX_RED',
		'siteMsg',
		'1452751825163',
		't',
		'zh_CN',
		'站长${userName}的站点“${siteName}”盈利上限已使用100%，风险较高，建议您及时联系站长，提高盈利上限！',
		'站长${userName}的站点“${siteName}”盈利上限已使用100%，风险较高，建议您及时联系站长，提高盈利上限！该站点目前盈利上限${maxProfit}，当前盈利${rofit}！${view}',
		't',
		'title',
		'content',
		'2015-11-12 08:30:54.267665',
		'1',
		NULL,
		NULL,
		't'
WHERE 'PROFIT_MAX_RED' NOT in(SELECT event_type from notice_tmpl WHERE tmpl_type='manual' AND publish_method='siteMsg' AND locale='zh_CN');

INSERT INTO "notice_tmpl" ("tmpl_type","event_type","publish_method","group_code",	"active","locale","title","content","default_active",	"default_title","default_content","create_time","create_user",	"update_time","update_user",	"built_in")
SELECT
		'manual',
		'PROFIT_MAX_RED',
		'siteMsg',
		'1452751825163',
		't',
		'en_US',
				'站长${userName}的站点“${siteName}”盈利上限已使用100%，风险较高，建议您及时联系站长，提高盈利上限！',
		'站长${userName}的站点“${siteName}”盈利上限已使用100%，风险较高，建议您及时联系站长，提高盈利上限！该站点目前盈利上限${maxProfit}，当前盈利${rofit}！${view}',
		't',
		'title',
		'content',
		'2015-11-12 08:30:54.267665',
		'1',
		NULL,
		NULL,
		't'
WHERE 'PROFIT_MAX_RED' NOT in(SELECT event_type from notice_tmpl WHERE tmpl_type='manual' AND publish_method='siteMsg' AND locale='en_US');

INSERT INTO "notice_tmpl" ("tmpl_type","event_type","publish_method","group_code",	"active","locale","title","content","default_active",	"default_title","default_content","create_time","create_user",	"update_time","update_user",	"built_in")
SELECT
		'manual',
		'PROFIT_MAX_RED',
		'siteMsg',
		'1452751825163',
		't',
		'zh_TW',
				'站长${userName}的站点“${siteName}”盈利上限已使用100%，风险较高，建议您及时联系站长，提高盈利上限！',
		'站长${userName}的站点“${siteName}”盈利上限已使用100%，风险较高，建议您及时联系站长，提高盈利上限！该站点目前盈利上限${maxProfit}，当前盈利${rofit}！${view}',
		't',
		'title',
		'content',
		'2015-11-12 08:30:54.267665',
		'1',
		NULL,
		NULL,
		't'
WHERE 'PROFIT_MAX_RED' NOT in(SELECT event_type from notice_tmpl WHERE tmpl_type='manual' AND publish_method='siteMsg' AND locale='zh_TW');


INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_audit', 'sjkd', 'musics/audit/sjkd.wav', '2000', '4', '时间快到', NULL, 't', NULL
WHERE  'sjkd' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_audit');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_audit', 'trill', 'musics/audit/trill.wav', '2000', '1', 'Trill', NULL, 't', NULL
WHERE  'trill' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_audit');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_audit', 'sxsjls', 'musics/audit/sxsjls.wav', '3000', '2', '三星手机铃声', NULL, 't', NULL
WHERE  'sxsjls' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_audit');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_audit', 'sjhxyx2', 'musics/audit/sjhxyx2.wav', '3000', '3', '手机和弦音效2', NULL, 't', NULL
WHERE  'sjhxyx2' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_audit');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'sys_tone_audit', 'spyx', 'musics/audit/spyx.wav', '3000', '5', '审批音效', NULL, 't', NULL
WHERE  'spyx' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_audit');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_warm', 'jss1', 'musics/warm/jss1.wav', '3000', '3', '警示声1', NULL, 't', NULL
WHERE  'jss1' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_warm');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'sys_tone_warm', 'jss3', 'musics/warm/jss3.wav', '3000', '5', '警示声3', NULL, 't', NULL
WHERE  'jss3' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_warm');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'sys_tone_warm', 'jls', 'musics/warm/jls.wav', '3000', '6', '警铃声', NULL, 't', NULL
WHERE  'jls' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_warm');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_warm', 'lhjs', 'musics/warm/lhjs.wav', '2000', '1', '老虎机声-警报声', NULL, 't', NULL
WHERE  'jls' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_warm');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_warm', 'jss2', 'musics/warm/jss2.wav', '4000', '4', '警示声2', NULL, 't', NULL
WHERE  'jss2' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_warm');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'sys_tone_warm', 'jbs', 'musics/warm/jbs.wav', '3000', '2', '警报声', NULL, 't', NULL
WHERE  'jbs' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_warm');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_notice', 'sjdxy', 'musics/notice/sjdxy.wav', '2000', '2', '手机短信音', NULL, 't', NULL
WHERE  'sjdxy' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_notice');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'sys_tone_notice', 'sxdxtsy', 'musics/notice/sxdxtsy.wav', '1000', '2', '三星短信提示音', NULL, 't', NULL
WHERE  'sxdxtsy' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_notice');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'sys_tone_notice', 'xxxtx', 'musics/notice/xxxtx.wav', '3000', '2', '新消息提醒-英文', NULL, 't', NULL
WHERE  'xxxtx' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_notice');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'setting', 'sys_tone_notice', 'nlyx', 'musics/notice/nlyx.wav', '3000', '2', '闹铃音效', NULL, 't', NULL
WHERE  'nlyx' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_notice');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT  'setting', 'sys_tone_notice', 'sjhxyx', 'musics/notice/sjhxyx.wav', '2000', '2', '手机和弦音效', NULL, 't', NULL
WHERE  'sjhxyx' NOT in(SELECT param_code FROM sys_param WHERE module='setting' AND param_type='sys_tone_notice');

DROP TABLE IF EXISTS "user_task_reminder";

CREATE TABLE IF NOT EXISTS "user_task_reminder" (

"id" serial4 NOT NULL,

"dict_code" varchar(32) COLLATE "default",

"update_time" timestamp(6),

"task_num" int4,

"task_url" varchar(128) COLLATE "default",

"parent_code" varchar(32) COLLATE "default",

"remark" varchar(100) COLLATE "default",

"param_value" varchar(128) COLLATE "default",

"tone_type" varchar(50) COLLATE "default"

)

WITH (OIDS=FALSE)

;

COMMENT ON TABLE "user_task_reminder" IS '任务表--Jerry';

COMMENT ON COLUMN "user_task_reminder"."dict_code" IS '字典CODE  withdrawAudit取款审批待处理；monthClose 月结账单；nextMonth下月消费预计账单；';

COMMENT ON COLUMN "user_task_reminder"."update_time" IS '任务的最后更新时间';

COMMENT ON COLUMN "user_task_reminder"."task_num" IS '单个任务类型总条数';

COMMENT ON COLUMN "user_task_reminder"."task_url" IS '查看任务类型URL';

COMMENT ON COLUMN "user_task_reminder"."parent_code" IS '任务类型归类';

COMMENT ON COLUMN "user_task_reminder"."remark" IS '备注';

COMMENT ON COLUMN "user_task_reminder"."param_value" IS '参数值:json串';

COMMENT ON COLUMN "user_task_reminder"."tone_type" IS '声音类型：sys_param:dict_type=warming_tone_project';



