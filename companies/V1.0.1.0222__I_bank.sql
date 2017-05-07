-- auto gen by brave 2016-11-28 13:22:31
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '84', 'xunhuibaopay_wx', NULL, 'CN', '3', '迅汇宝-微信支付', NULL, '迅汇宝', 't', NULL, NULL, '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='xunhuibaopay_wx');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '85', 'xunhuibaopay_zfb', NULL, 'CN', '3', '迅汇宝-支付宝', NULL, '迅汇宝', 't', NULL, NULL, '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='xunhuibaopay_zfb');
