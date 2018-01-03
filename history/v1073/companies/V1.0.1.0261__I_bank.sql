-- auto gen by cherry 2017-03-27 20:14:46

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use",  "order_num", "pay_type", "website")
SELECT '119', 'xtc_zfb', NULL, 'CN', '3', '新天诚-支付宝', NULL, '新天诚', 't',243, '3', NULL
WHERE not EXISTS(SELECT id FROM bank where id=119);

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
SELECT '118', 'xtc_wx', NULL, 'CN', '3', '新天诚-微信支付', NULL, '新天诚', 't', 242, '2', NULL
WHERE not EXISTS(SELECT id FROM bank where id=118);

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use","order_num", "pay_type", "website")
SELECT '117', 'xtc', NULL, 'CN', '3', '新天诚-网银', NULL, '新天诚', 't', 241, '1', NULL
WHERE not EXISTS(SELECT id FROM bank where id=117);