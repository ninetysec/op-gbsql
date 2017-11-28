-- auto gen by brave 2017-01-04 11:53:39
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
SELECT '92', 'helibaowy', NULL, 'CN', '3', '合利宝-网银', NULL, '合利宝', 't', NULL, NULL, '1', NULL
WHERE not EXISTS(SELECT id FROM bank where bank_name='helibaowy');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
SELECT '93', 'helibao_wx', NULL, 'CN', '3', '合利宝-微信支付', NULL, '合利宝', 't', NULL, NULL, '2', NULL
WHERE not EXISTS(SELECT id FROM bank where bank_name='helibao_wx');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
SELECT '94', 'helibao_zfb', NULL, 'CN', '3', '合利宝-支付宝', NULL, '合利宝', 't', NULL, NULL, '3', NULL
WHERE not EXISTS(SELECT id FROM bank where bank_name='helibao_zfb');