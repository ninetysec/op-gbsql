-- auto gen by cherry 2017-05-18 09:24:23
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '158', 'tianchuang_wx', NULL, 'CN', '3', '天创-微信支付', NULL, '天创', 't', '202', '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='tianchuang_wx');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '164', 'xunjietong_wx', NULL, 'CN', '3', '迅捷通-微信支付', NULL, '迅捷通', 't', '242', '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='xunjietong_wx');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '165', 'xunjietong_zfb', NULL, 'CN', '3', '迅捷通-支付宝', NULL, '迅捷通', 't', '243', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='xunjietong_zfb');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '159', 'tianchuang_zfb', NULL, 'CN', '3', '天创-支付宝', NULL, '天创', 't', '203', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='tianchuang_zfb');
