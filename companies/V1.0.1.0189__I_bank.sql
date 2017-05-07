-- auto gen by wayne 2016-09-30 11:31:30

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '63', 'jinanpay_wx', NULL, 'CN', '3', '金安付-微信支付', NULL, '金安付', 't', NULL, NULL, '2', NULL WHERE 63 NOT IN(SELECT id FROM bank WHERE id=63);

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '64', 'jinanpay_zfb', NULL, 'CN', '3', '金安付-支付宝', NULL, '金安付', 't', NULL, NULL, '3', NULL WHERE 64 NOT IN(SELECT id FROM bank WHERE id=64);


