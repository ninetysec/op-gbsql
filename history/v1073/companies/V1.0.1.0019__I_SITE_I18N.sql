--赛事推荐初始化site_i18n数据
INSERT INTO "site_i18n" (
	"module",
	"type",
	"key",
	"locale",
	"value",
	"site_id",
	"remark",
	"default_value",
	"built_in"
)
SELECT
		'sport_recommended',
		'match_type',
		'2',
		'en_US',
		'欧联杯',
		'0',
		'比赛类型',
		NULL,
		't'
	WHERE '欧联杯' NOT IN (SELECT value FROM site_i18n where module = 'sport_recommended' AND type = 'match_type' AND locale = 'en_US');

INSERT INTO "site_i18n" (
	"module",
	"type",
	"key",
	"locale",
	"value",
	"site_id",
	"remark",
	"default_value",
	"built_in"
)
	SELECT
		'sport_recommended',
		'match_type',
		'2',
		'zh_CN',
		'欧联杯_CN',
		'0',
		'比赛类型',
		NULL,
		't'
	WHERE '欧联杯_CN' NOT IN (SELECT value FROM site_i18n where module = 'sport_recommended' AND type = 'match_type' AND locale = 'zh_CN');

INSERT INTO "site_i18n" (
	"module",
	"type",
	"key",
	"locale",
	"value",
	"site_id",
	"remark",
	"default_value",
	"built_in"
)
SELECT
		'sport_recommended',
		'match_type',
		'2',
		'zh_TW',
		'欧联杯_TW',
		'0',
		'比赛类型',
		NULL,
		't'
WHERE '欧联杯_TW' NOT IN (SELECT value FROM site_i18n where module = 'sport_recommended' AND type = 'match_type' AND locale = 'zh_TW');

INSERT INTO "site_i18n" (
	"module",
	"type",
	"key",
	"locale",
	"value",
	"site_id",
	"remark",
	"default_value",
	"built_in"
)
SELECT
		'sport_recommended',
		'match_type',
		'1',
		'en_US',
		'西甲',
		'0',
		'比赛类型',
		NULL,
		't'
WHERE '西甲' NOT IN (SELECT value FROM site_i18n where module = 'sport_recommended' AND type = 'match_type' AND locale = 'en_US');

INSERT INTO "site_i18n" (
	"module",
	"type",
	"key",
	"locale",
	"value",
	"site_id",
	"remark",
	"default_value",
	"built_in"
)
	SELECT
		'sport_recommended',
		'match_type',
		'1',
		'zh_CN',
		'西甲_CN',
		'0',
		'比赛类型',
		NULL,
		't'
WHERE '西甲_CN' NOT IN (SELECT value FROM site_i18n where module = 'sport_recommended' AND type = 'match_type' AND locale = 'zh_CN');

INSERT INTO "site_i18n" (
	"module",
	"type",
	"key",
	"locale",
	"value",
	"site_id",
	"remark",
	"default_value",
	"built_in"
)
SELECT
		'sport_recommended',
		'match_type',
		'1',
		'zh_TW',
		'西甲_TW',
		'0',
		'比赛类型',
		NULL,
		't'
WHERE '西甲_TW' NOT IN (SELECT value FROM site_i18n where module = 'sport_recommended' AND type = 'match_type' AND locale = 'zh_TW');
INSERT INTO "site_i18n" (
	"module",
	"type",
	"key",
	"locale",
	"value",
	"site_id",
	"remark",
	"default_value",
	"built_in"
)
SELECT
		'sport_recommended',
		'team_type',
		'1',
		'zh_CN',
		'球队类型1',
		'0',
		'球队类型',
		NULL,
		't'
WHERE '1' NOT IN (SELECT key from site_i18n WHERE module = 'sport_recommended' AND type = 'team_type' AND locale = 'zh_CN');

INSERT INTO "site_i18n" (
	"module",
	"type",
	"key",
	"locale",
	"value",
	"site_id",
	"remark",
	"default_value",
	"built_in"
)
SELECT
		'sport_recommended',
		'team_type',
		'1',
		'zh_TW',
		'球队类型1',
		'0',
		'球队类型',
		NULL,
		't'
WHERE '1' NOT IN (SELECT key from site_i18n WHERE module = 'sport_recommended' AND type = 'team_type' AND locale = 'zh_TW');

INSERT INTO "site_i18n" (
	"module",
	"type",
	"key",
	"locale",
	"value",
	"site_id",
	"remark",
	"default_value",
	"built_in"
)
SELECT
		'sport_recommended',
		'team_type',
		'1',
		'en_US',
		'球队类型1',
		'0',
		'球队类型',
		NULL,
		't'
WHERE '1' NOT IN (SELECT key from site_i18n WHERE module = 'sport_recommended' AND type = 'team_type' AND locale = 'en_US');

INSERT INTO "site_i18n" (
	"module",
	"type",
	"key",
	"locale",
	"value",
	"site_id",
	"remark",
	"default_value",
	"built_in"
)
SELECT
		'sport_recommended',
		'team_type',
		'3',
		'zh_CN',
		'球队类型3',
		'0',
		'球队类型',
		NULL,
		't'
WHERE '3' NOT IN (SELECT key from site_i18n WHERE module = 'sport_recommended' AND type = 'team_type' AND locale = 'zh_CN');

INSERT INTO "site_i18n" (
	"module",
	"type",
	"key",
	"locale",
	"value",
	"site_id",
	"remark",
	"default_value",
	"built_in"
)
SELECT
		'sport_recommended',
		'team_type',
		'2',
		'zh_CN',
		'球队类型2',
		'0',
		'球队类型',
		NULL,
		't'
WHERE '2' NOT IN (SELECT key from site_i18n WHERE module = 'sport_recommended' AND type = 'team_type' AND locale = 'zh_CN');

INSERT INTO "site_i18n" (
	"module",
	"type",
	"key",
	"locale",
	"value",
	"site_id",
	"remark",
	"default_value",
	"built_in"
)
SELECT
		'sport_recommended',
		'team_type',
		'3',
		'zh_TW',
		'球队类型3',
		'0',
		'球队类型',
		NULL,
		't'
WHERE '3' NOT IN (SELECT key from site_i18n WHERE module = 'sport_recommended' AND type = 'team_type' AND locale = 'zh_TW');

INSERT INTO "site_i18n" (
	"module",
	"type",
	"key",
	"locale",
	"value",
	"site_id",
	"remark",
	"default_value",
	"built_in"
)
SELECT
		'sport_recommended',
		'team_type',
		'2',
		'zh_TW',
		'球队类型2',
		'0',
		'球队类型',
		NULL,
		't'
WHERE '2' NOT IN (SELECT key from site_i18n WHERE module = 'sport_recommended' AND type = 'team_type' AND locale = 'zh_TW');

INSERT INTO "site_i18n" (
	"module",
	"type",
	"key",
	"locale",
	"value",
	"site_id",
	"remark",
	"default_value",
	"built_in"
)
SELECT
		'sport_recommended',
		'team_type',
		'2',
		'en_US',
		'球队类型2',
		'0',
		'球队类型',
		NULL,
		't'
WHERE '2' NOT IN (SELECT key from site_i18n WHERE module = 'sport_recommended' AND type = 'team_type' AND locale = 'en_US');

INSERT INTO "site_i18n" (
	"module",
	"type",
	"key",
	"locale",
	"value",
	"site_id",
	"remark",
	"default_value",
	"built_in"
)
SELECT
		'sport_recommended',
		'team_type',
		'3',
		'en_US',
		'球队类型2',
		'0',
		'球队类型',
		NULL,
		't'
WHERE '3' NOT IN (SELECT key from site_i18n WHERE module = 'sport_recommended' AND type = 'team_type' AND locale = 'en_US');
