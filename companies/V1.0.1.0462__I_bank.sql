-- auto gen by george 2017-11-01 21:08:51
INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
SELECT 'qqwallet', NULL, 'CN', '2', 'QQ钱包', NULL, 'QQ钱包', 't', NULL, '29', NULL, NULL
WHERE not EXISTS(SELECT id FROM bank where bank_name='qqwallet');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
SELECT 'jdwallet', NULL, 'CN', '2', '京东钱包', NULL, '京东钱包', 't', NULL, '30', NULL, NULL
WHERE not EXISTS(SELECT id FROM bank where bank_name='jdwallet');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
SELECT 'bdwallet', NULL, 'CN', '2', '百度钱包', NULL, '百度钱包', 't', NULL, '31', NULL, NULL
WHERE not EXISTS(SELECT id FROM bank where bank_name='bdwallet');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
SELECT 'onecodepay', NULL, 'CN', '2', '一码付', NULL, '一码付', 't', NULL, '32', NULL, NULL
WHERE not EXISTS(SELECT id FROM bank where bank_name='onecodepay');