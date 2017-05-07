-- auto gen by cherry 2017-03-07 20:11:24
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '111', 'xunbao', NULL, 'CN', '3', '讯宝支付-网银', NULL, '讯宝支付', 't', 241, '1', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='xunbao');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '112', 'xunbao_wx', NULL, 'CN', '3', '讯宝支付-微信支付', NULL, '讯宝支付', 't', 242, '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='xunbao_wx');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '113', 'xunbao_zfb', NULL, 'CN', '3', '讯宝支付-支付宝', NULL, '讯宝支付', 't', 243, '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='xunbao_zfb');