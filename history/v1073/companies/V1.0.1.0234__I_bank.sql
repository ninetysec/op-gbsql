-- auto gen by brave 2016-12-16 01:33:21
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use","order_num", "pay_type", "website")
SELECT '86', 'xinbei', NULL, 'CN', '3', '新贝-网银', NULL, '新贝', 't', NULL, '1', NULL
WHERE not EXISTS(SELECT id FROM bank where bank_name='xinbei');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
SELECT '87', 'xinbei_wx', NULL, 'CN', '3', '新贝-微信支付', NULL, '新贝', 't',  NULL, '2', NULL
WHERE not EXISTS(SELECT id FROM bank where bank_name='xinbei_wx');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
SELECT '88', 'xinbei_zfb', NULL, 'CN', '3', '新贝-支付宝', NULL, '新贝', 't', NULL, '3', NULL
WHERE not EXISTS(SELECT id FROM bank where bank_name='xinbei_zfb');