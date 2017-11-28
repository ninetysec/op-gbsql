-- auto gen by cherry 2017-06-16 14:52:29

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")

  SELECT 'baolifu_wy', NULL, 'CN', '3', '宝立付支付-网银支付', NULL, '宝立付支付', 't', '021','1', NULL

  WHERE not EXISTS(SELECT id FROM bank where bank_name='baolifu_wy');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")

  SELECT 'baolifu_wx', NULL, 'CN', '3', '宝立付支付-微信支付', NULL, '宝立付支付', 't', '022', '2', NULL

  WHERE not EXISTS(SELECT id FROM bank where bank_name='baolifu_wx');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")

  SELECT 'baolifu_zfb', NULL, 'CN', '3', '宝立付支付-支付宝', NULL, '宝立付支付', 't', '023', '3', NULL

  WHERE not EXISTS(SELECT id FROM bank where bank_name='baolifu_zfb');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")

  SELECT 'duobaopay_wy', NULL, 'CN', '3', '多宝支付-网银支付', NULL, '多宝支付', 't', '041', '1', NULL

  WHERE not EXISTS(SELECT id FROM bank where bank_name='duobaopay_wy');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")

  SELECT 'duobaopay_wx', NULL, 'CN', '3', '多宝支付-微信支付', NULL, '多宝支付', 't', '042', '2', NULL

  WHERE not EXISTS(SELECT id FROM bank where bank_name='duobaopay_wx');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")

  SELECT 'duobaopay_zfb', NULL, 'CN', '3', '多宝支付-支付宝', NULL, '多宝支付', 't', '043', '3', NULL

  WHERE not EXISTS(SELECT id FROM bank where bank_name='duobaopay_zfb');

