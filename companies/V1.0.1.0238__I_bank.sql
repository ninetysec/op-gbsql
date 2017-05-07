-- auto gen by cherry 2016-12-28 22:03:01
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
SELECT '91', 'xunfutong_zfb', NULL, 'CN', '3', '讯付通-支付宝', NULL, '讯付通', 't', NULL, '3', NULL
WHERE not EXISTS (SELECT id FROM bank where id=91);

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
SELECT '90', 'xunfutong_wx', NULL, 'CN', '3', '讯付通-微信', NULL, '讯付通', 't', NULL, '2', NULL
WHERE not EXISTS (SELECT id FROM bank where id=90);

--INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use",  "order_num", "pay_type", "website")
--SELECT '89', 'xunfutong-wap_zfb', NULL, 'CN', '3', '讯付通-支付宝直连（手机端）', NULL, '讯付通', 't',  NULL, '3', NULL
--WHERE not EXISTS (SELECT id FROM bank where id=89);