-- auto gen by wayne 2016-08-22 20:47:30

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '55', 'rfupay', NULL, 'CN', '3', '锐付支付', NULL, '锐付', 't', NULL, NULL, '1', NULL WHERE 55 NOT IN(SELECT id FROM bank WHERE id=55);
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '56', 'rfupay_wx', NULL, 'CN', '3', '锐付-微信支付', NULL, '锐付', 't', NULL, NULL, '2', NULL WHERE 56 NOT IN(SELECT id FROM bank WHERE id=56);


INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '57', '9pay', NULL, 'CN', '3', '久付支付', NULL, '久付', 't', NULL, NULL, '1', NULL WHERE 57 NOT IN(SELECT id FROM bank WHERE id=57);
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '58', '9pay_wx', NULL, 'CN', '3', '久付-微信支付', NULL, '久付', 't', NULL, NULL, '2', NULL WHERE 58 NOT IN(SELECT id FROM bank WHERE id=58);

