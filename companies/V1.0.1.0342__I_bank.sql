-- auto gen by cherry 2017-07-04 09:24:39
INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'qingyifu_wx', NULL, 'CN', '3', '轻易付-微信支付', NULL, '轻易付', 't', '172', '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='qingyifu_wx');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'qingyifu_zfb', NULL, 'CN', '3', '轻易付-支付宝', NULL, '轻易付', 't', '173', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='qingyifu_zfb');
