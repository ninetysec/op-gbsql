-- auto gen by cherry 2017-01-17 14:25:08
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use",  "order_num", "pay_type", "website")
SELECT '99', 'lefu_zfb', NULL, 'CN', '3', '乐付宝-支付宝', NULL, '乐付宝', 't',NULL, '3', NULL
WHERE not EXISTS(SELECT id FROM bank where id=99);

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
SELECT '100', 'lefu_wx', NULL, 'CN', '3', '乐付宝-微信支付', NULL, '乐付宝', 't', NULL, '2', NULL
WHERE not EXISTS(SELECT id FROM bank where id=100);

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use","order_num", "pay_type", "website")
SELECT '101', 'lefu', NULL, 'CN', '3', '乐付宝-网银', NULL, '乐付宝', 't', NULL, '1', NULL
WHERE not EXISTS(SELECT id FROM bank where id=101);