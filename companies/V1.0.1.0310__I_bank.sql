-- auto gen by cherry 2017-06-19 16:53:17
INSERT INTO "bank" (
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
)
SELECT
		'bitcoin',
		NULL,
		'CN',
		'2',
		'比特币',
		NULL,
		'比特币',
		't',
		NULL,
		NULL,
		NULL
where not EXISTS(SELECT bank_name FROM bank where bank_name='bitcoin');

INSERT INTO"bank_support_currency" ("bank_code", "currency_name", "currency_code")
SELECT 'bitcoin', '比特币', 'JPY'
where not EXISTS(SELECT id FROM bank_support_currency WHERE bank_code='bitcoin' and currency_code='JPY');

