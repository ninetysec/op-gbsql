-- auto gen by cherry 2016-12-14 09:33:44
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
SELECT '52', 'allscore', NULL, 'CN', '3', '商银信', NULL, '商银信', 't', NULL, '51', '1', NULL
WHERE NOT EXISTS(SELECT id FROM bank WHERE id=52)