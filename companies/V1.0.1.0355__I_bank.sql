-- auto gen by cherry 2017-07-07 19:26:10
INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'shunbao', NULL, 'CN', '3', '顺宝支付-网银', NULL, '顺宝支付', 't', '191', '1', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='shunbao');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'shunbao_wx', NULL, 'CN', '3', '顺宝支付-微信支付', NULL, '顺宝支付', 't', '192', '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='shunbao_wx');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'shunbao_zfb', NULL, 'CN', '3', '顺宝支付-支付宝', NULL, '顺宝支付', 't', '193', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='shunbao_zfb');


