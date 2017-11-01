-- auto gen by george 2017-11-01 21:10:20
INSERT INTO "bank_support_currency" ("bank_code", "currency_name", "currency_code")
SELECT 'qqwallet', 'QQ钱包', 'CNY'
WHERE not EXISTS(SELECT id FROM bank_support_currency where bank_code='qqwallet');

INSERT INTO "bank_support_currency" ("bank_code", "currency_name", "currency_code")
SELECT 'jdwallet', '京东钱包', 'CNY'
WHERE not EXISTS(SELECT id FROM bank_support_currency where bank_code='jdwallet');

INSERT INTO "bank_support_currency" ("bank_code", "currency_name", "currency_code")
SELECT 'bdwallet', '百度钱包', 'CNY'
WHERE not EXISTS(SELECT id FROM bank_support_currency where bank_code='bdwallet');

INSERT INTO "bank_support_currency" ("bank_code", "currency_name", "currency_code")
SELECT 'onecodepay', '一码付', 'CNY'
WHERE not EXISTS(SELECT id FROM bank_support_currency where bank_code='onecodepay');