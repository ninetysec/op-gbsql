-- auto gen by cherry 2017-06-19 11:27:49
INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")

  SELECT 'xuntongbao_wy', NULL, 'CN', '3', '讯通宝支付-网银支付', NULL, '讯通宝支付', 't', '241','1', NULL

  WHERE not EXISTS(SELECT id FROM bank where bank_name='xuntongbao_wy');



INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")

  SELECT 'xuntongbao_wx', NULL, 'CN', '3', '讯通宝支付-微信支付', NULL, '讯通宝支付', 't', '242', '2', NULL

  WHERE not EXISTS(SELECT id FROM bank where bank_name='xuntongbao_wx');



INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")

  SELECT 'xuntongbao_zfb', NULL, 'CN', '3', '讯通宝支付-支付宝', NULL, '讯通宝支付', 't', '243', '3', NULL

  WHERE not EXISTS(SELECT id FROM bank where bank_name='xuntongbao_zfb');