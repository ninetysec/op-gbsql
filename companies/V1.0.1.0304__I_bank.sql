-- auto gen by cherry 2017-06-14 15:56:20
INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'yunfux_wx', NULL, 'CN', '3', '云付盟支付-微信支付', NULL, '云付盟支付', 't', '252', '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='yunfux_wx');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'yunfux_zfb', NULL, 'CN', '3', '云付盟支付-支付宝', NULL, '云付盟支付', 't', '253', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='yunfux_zfb');

  INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'woozf_wy', NULL, 'CN', '3', '沃支付-网银支付', NULL, '沃支付', 't', '231','1', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='woozf_wy');