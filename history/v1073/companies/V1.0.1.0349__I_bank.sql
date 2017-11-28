-- auto gen by cherry 2017-07-05 11:57:07
INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'yuanqi_wx', NULL, 'CN', '3', '元启支付-微信支付', NULL, '元启支付', 't', '252', '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='yuanqi_wx');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'yuanqi_zfb', NULL, 'CN', '3', '元启支付-支付宝', NULL, '元启支付', 't', '253', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='yuanqi_zfb');