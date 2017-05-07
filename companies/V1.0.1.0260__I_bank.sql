-- auto gen by cherry 2017-03-21 11:34:08
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '114', 'shufu', NULL, 'CN', '3', '舒付支付-网银', NULL, '舒付支付', 't', '191', '1', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='shufu');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '115', 'shufu_wx', NULL, 'CN', '3', '舒付支付-微信支付', NULL, '舒付支付', 't', '192', '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='shufu_wx');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '116', 'shufu_zfb', NULL, 'CN', '3', '舒付支付-支付宝', NULL, '舒付支付', 't', '193', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='shufu_zfb');