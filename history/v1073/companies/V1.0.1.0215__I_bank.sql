-- auto gen by wayne 2016-11-13 21:57:31
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '73', 'funpay', NULL, 'CN', '3', '乐盈支付-网银', NULL, '乐盈支付', 't', NULL, NULL, '1', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='funpay');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '74', 'funpay_wx', NULL, 'CN', '3', '乐盈支付-微信支付', NULL, '乐盈支付', 't', NULL, NULL, '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='funpay_wx');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '75', 'funpay_zfb', NULL, 'CN', '3', '乐盈支付-支付宝', NULL, '乐盈支付', 't', NULL, NULL, '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='funpay_zfb');
