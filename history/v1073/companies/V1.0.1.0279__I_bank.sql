-- auto gen by cherry 2017-05-16 19:46:32
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '160', 'dinpay_zfb', NULL, 'CN', '3', '智付-支付宝', NULL, '智付', 't', '003', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='dinpay_zfb');