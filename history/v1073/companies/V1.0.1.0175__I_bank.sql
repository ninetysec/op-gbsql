-- auto gen by wayne 2016-09-12 23:07:30

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '61', 'tonghui_wx', NULL, 'CN', '3', '通汇-微信支付', NULL, '通汇', 't', NULL, NULL, '2', NULL WHERE 61 NOT IN(SELECT id FROM bank WHERE id=61);

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT '62', 'tonghui_zfb', NULL, 'CN', '3', '通汇-支付宝', NULL, '通汇', 't', NULL, NULL, '3', NULL WHERE 62 NOT IN(SELECT id FROM bank WHERE id=62);


