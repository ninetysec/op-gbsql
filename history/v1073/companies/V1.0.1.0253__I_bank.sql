-- auto gen by cherry 2017-03-01 13:58:44
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '108', 'anfu', NULL, 'CN', '3', '安付支付-网银', NULL, '安付支付', 't', 101, '1', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='anfu');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '109', 'anfu_wx', NULL, 'CN', '3', '安付支付-微信支付', NULL, '安付支付', 't', 201, '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='anfu_wx');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '110', 'anfu_zfb', NULL, 'CN', '3', '安付支付-支付宝', NULL, '安付支付', 't', 301, '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='anfu_zfb');