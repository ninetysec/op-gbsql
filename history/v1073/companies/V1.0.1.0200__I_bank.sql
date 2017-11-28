-- auto gen by gamebox 2016-10-19 17:26:37
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '67', 'ybpay', NULL, 'CN', '3', '银宝-网银', NULL, '银宝', 't', NULL, NULL, '1', NULL
  WHERE NOT EXISTS (select id from bank where id = 67);

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '68', 'ybpay_wx', NULL, 'CN', '3', '银宝-微信支付', NULL, '银宝', 't', NULL, NULL, '2', NULL
  WHERE NOT EXISTS (select id from bank where id = 68);

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '69', 'ybpay_zfb', NULL, 'CN', '3', '银宝-支付宝', NULL, '银宝', 't', NULL, NULL, '3', NULL
  WHERE NOT EXISTS (select id from bank where id = 69);
