-- auto gen by george 2018-01-04 16:04:36
INSERT INTO "currency_exchange_rate" ("ifrom_currency", "ito_currency", "rate", "remark", "update_time", "update_user")
SELECT 'CNY', 'JPY', '17.285', NULL, NULL, NULL
WHERE NOT EXISTS (select ifrom_currency,ito_currency from currency_exchange_rate where ifrom_currency = 'CNY' AND ito_currency='JPY');

INSERT INTO "currency_exchange_rate" ("ifrom_currency", "ito_currency", "rate", "remark", "update_time", "update_user")
SELECT 'JPY', 'CNY', '0.0577', NULL, NULL, NULL
WHERE NOT EXISTS (select ifrom_currency,ito_currency from currency_exchange_rate where ifrom_currency = 'JPY' AND ito_currency='CNY');