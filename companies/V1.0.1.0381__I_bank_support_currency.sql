-- auto gen by cherry 2017-08-04 11:31:15
INSERT INTO "bank_support_currency" ("bank_code", "currency_name", "currency_code")
SELECT 'bitcoin', '比特币', 'CNY' WHERE not EXISTS (SELECT id FROM bank_support_currency where bank_code='bitcoin' and currency_code='CNY');
