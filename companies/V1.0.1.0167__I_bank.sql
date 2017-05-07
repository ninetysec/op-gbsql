-- auto gen by brave 2016-10-08 14:50:59

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '65', 'rfupay_zfb', NULL, 'CN', '3', '锐付-支付宝', NULL, '锐付', 't', NULL, NULL, '3', NULL
  WHERE NOT EXISTS (select id from bank where id = 65);
