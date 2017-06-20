-- auto gen by cherry 2017-06-20 09:24:33

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT  'qianyou_wx', NULL, 'CN', '3', 'QPay-微信支付', NULL, 'QPay', 't', '172', '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='qianyou_wx');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'qianyou_zfb', NULL, 'CN', '3', 'QPay-支付宝', NULL, 'QPay', 't', '173', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='qianyou_zfb');