-- auto gen by brave 2016-11-19 11:52:08
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '78', 'qianwangpay', NULL, 'CN', '3', '千网-网银', NULL, '千网', 't', NULL, NULL, '1', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='qianwangpay');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '79', 'qianwangpay_wx', NULL, 'CN', '3', '千网-微信支付', NULL, '千网', 't', NULL, NULL, '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='qianwangpay_wx');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '80', 'qianwangpay_zfb', NULL, 'CN', '3', '千网-支付宝', NULL, '千网', 't', NULL, NULL, '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='qianwangpay_zfb');
