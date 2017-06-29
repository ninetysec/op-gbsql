-- auto gen by cherry 2017-06-29 14:36:25
INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'duoduo', NULL, 'CN', '3', '多多支付-网银', NULL, '多多支付', 't', '041', '1', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='duoduo');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'duoduo_wx', NULL, 'CN', '3', '多多支付-微信支付', NULL, '多多支付', 't', '042', '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='duoduo_wx');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'duoduo_zfb', NULL, 'CN', '3', '多多支付-支付宝', NULL, '多多支付', 't', '043', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='duoduo_zfb');

