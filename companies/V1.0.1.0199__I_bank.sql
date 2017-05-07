-- auto gen by brave 2016-10-16 19:25:07

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
SELECT '66', 'heepay_wx', NULL, 'CN', '3', '汇付宝-微信支付', NULL, '汇付宝', 't', NULL, NULL, '2', NULL
WHERE NOT EXISTS (select id from bank where id = 66);

