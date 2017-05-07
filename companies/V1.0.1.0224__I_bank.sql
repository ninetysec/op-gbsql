-- auto gen by cherry 2016-12-03 15:18:32
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use","order_num", "pay_type", "website")
SELECT '81', 'yinbang', NULL, 'CN', '3', '银邦-网银', NULL, '银邦', 't',NULL, '1', NULL
WHERE not EXISTS(SELECT id FROM bank where bank_name='yinbang');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
SELECT '82', 'yinbang_wx', NULL, 'CN', '3', '银邦-微信支付', NULL, '银邦', 't', NULL, '2', NULL
WHERE not EXISTS(SELECT id FROM bank where bank_name='yinbang_wx');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
SELECT '83', 'yinbang_zfb', NULL, 'CN', '3', '银邦-支付宝', NULL, '银邦', 't',NULL, '3', NULL
WHERE not EXISTS(SELECT id FROM bank where bank_name='yinbang_zfb');