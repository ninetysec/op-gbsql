-- auto gen by cherry 2017-01-09 16:31:27
INSERT INTO "bank" (
	"id",
	"bank_name",
	"bank_icon",
	"bank_district",
	"type",
	"bank_short_name",
	"bank_icon_simplify",
	"bank_short_name2",
	"is_use",
	"order_num",
	"pay_type",
	"website"
) SELECT
	'95',
	'yinbang_kj',
	NULL,
	'CN',
	'3',
	'银邦-快捷支付',
	NULL,
	'银邦',
	't',
	NULL,
	'1',
	NULL
WHERE
	NOT EXISTS (
		SELECT
			ID
		FROM
			bank
		WHERE
			bank_name = 'yinbang_kj'
	);