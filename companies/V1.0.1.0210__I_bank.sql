-- auto gen by wayne 2016-11-08 19:54:31
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '70', 'okpay', NULL, 'CN', '3', 'OK付-网银', NULL, 'OK付', 't', NULL, NULL, '1', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='okpay');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '71', 'okpay_wx', NULL, 'CN', '3', 'OK付-微信支付', NULL, 'OK付', 't', NULL, NULL, '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='okpay_wx');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '72', 'okpay_zfb', NULL, 'CN', '3', 'OK付-支付宝', NULL, 'OK付', 't', NULL, NULL, '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='okpay_zfb');
