-- auto gen by cherry 2017-05-23 14:51:51
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '166', 'rongzhifu_wx', NULL, 'CN', '3', '融智付支付-微信支付', NULL, '融智付支付', 't', '182', '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='rongzhifu_wx');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '167', 'rongzhifu_zfb', NULL, 'CN', '3', '融智付支付-支付宝', NULL, '融智付支付', 't', '183', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='rongzhifu_zfb');