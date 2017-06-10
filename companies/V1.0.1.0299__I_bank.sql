-- auto gen by cherry 2017-06-09 11:03:24
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")

  SELECT '171', 'bifu', NULL, 'CN', '3', '必付支付-网银支付', NULL, '必付支付', 't', '021','1', NULL

  WHERE not EXISTS(SELECT id FROM bank where bank_name='bifu');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")

  SELECT '172', 'bifu_wx', NULL, 'CN', '3', '必付支付-微信支付', NULL, '必付支付', 't', '022', '2', NULL

  WHERE not EXISTS(SELECT id FROM bank where bank_name='bifu_wx');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")

  SELECT '173', 'bifu_zfb', NULL, 'CN', '3', '必付支付-支付宝', NULL, '必付支付', 't', '023', '3', NULL

  WHERE not EXISTS(SELECT id FROM bank where bank_name='bifu_zfb');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '177', 'baijie', NULL, 'CN', '3', '百捷支付-网银', NULL, '百捷支付', 't', '021', '1', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='baijie');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '178', 'baijie_wx', NULL, 'CN', '3', '百捷支付-微信支付', NULL, '百捷支付', 't', '022', '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='baijie_wx');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '179', 'baijie_zfb', NULL, 'CN', '3', '百捷支付-支付宝', NULL, '百捷支付', 't', '023', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='baijie_zfb');

  INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '162', 'hebao_wx', NULL, 'CN', '3', '荷包支付-微信支付', NULL, '荷包支付', 't', '082', '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='hebao_wx');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '163', 'hebao_zfb', NULL, 'CN', '3', '荷包支付-支付宝', NULL, '荷包支付', 't', '083', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='hebao_zfb');

  INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")

  SELECT '183', 'zbpay_wy', NULL, 'CN', '3', '众宝支付-网银支付', NULL, '众宝支付', 't', '261', '1', NULL

  WHERE not EXISTS(SELECT id FROM bank where bank_name='zbpay_wy');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")

  SELECT '184', 'zbpay_wx', NULL, 'CN', '3', '众宝支付-微信支付', NULL, '众宝支付', 't', '262', '2', NULL

  WHERE not EXISTS(SELECT id FROM bank where bank_name='zbpay_wx');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")

  SELECT '185', 'zbpay_zfb', NULL, 'CN', '3', '众宝支付-支付宝', NULL, '众宝支付', 't', '263', '3', NULL

  WHERE not EXISTS(SELECT id FROM bank where bank_name='zbpay_zfb');