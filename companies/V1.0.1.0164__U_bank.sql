-- auto gen by cherry 2016-09-02 16:29:29
UPDATE bank set bank_name='other_bank' WHERE bank_name='other' AND type='1';

INSERT INTO "bank_support_currency" ("bank_code", "currency_name", "currency_code")
SELECT 'other_bank', '其它', 'CNY'
where not EXISTS(SELECT id from bank_support_currency WHERE bank_code='other_bank' and currency_code='CNY');

