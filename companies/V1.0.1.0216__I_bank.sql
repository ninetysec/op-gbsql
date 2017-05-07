-- auto gen by cherry 2016-11-16 10:19:24
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
SELECT '77', 'allscore_s_wx', NULL, 'CN', '3', '商银信-扫码支付-微信支付', NULL, '商银信', 't', NULL, '2', NULL
where not EXISTS(SELECT id FROM bank where id=77);

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
SELECT '76', 'allscore_s_zfb', NULL, 'CN', '3', '商银信-扫码支付-支付宝', NULL, '商银信', 't', NULL, '3', NULL
where not EXISTS(SELECT id FROM bank where id=76);

