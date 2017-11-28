-- auto gen by cherry 2017-07-10 16:35:16
INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'leefu_wx', NULL, 'CN', '3', '乐付支付-微信支付', NULL, '乐付支付', 't', '122', '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='leefu_wx');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'leefu_zfb', NULL, 'CN', '3', '乐付支付-支付宝', NULL, '乐付支付', 't', '123', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='leefu_zfb');