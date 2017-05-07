-- auto gen by admin 2016-05-11 14:39:01
INSERT INTO  "bank_support_currency" ("bank_code", "currency_name", "currency_code")
SELECT 'other', '其它', ' CNY'
WHERE 'other' not  in(SELECT bank_code FROM bank_support_currency WHERE bank_code='other' AND currency_code='CNY');
