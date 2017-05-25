-- auto gen by cherry 2017-05-25 14:58:16


 INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")

  SELECT '168', 'xinmobao', NULL, 'CN', '3', '新摩宝-网银', NULL, '新摩宝', 't', '241', '1', NULL

  WHERE not EXISTS(SELECT id FROM bank where bank_name='xinmobao');



INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")

  SELECT '169', 'xinmobao_wx', NULL, 'CN', '3', '新摩宝-微信支付', NULL, '新摩宝', 't', '242', '2', NULL

  WHERE not EXISTS(SELECT id FROM bank where bank_name='xinmobao_wx');



INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")

  SELECT '170', 'xinmobao_zfb', NULL, 'CN', '3', '新摩宝-支付宝', NULL, '新摩宝', 't', '243', '3', NULL

  WHERE not EXISTS(SELECT id FROM bank where bank_name='xinmobao_zfb');