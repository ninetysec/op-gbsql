-- auto gen by cherry 2017-04-15 14:14:32

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use",  "order_num", "pay_type", "website")
SELECT '140', 'zhangzhifu_zfb', NULL, 'CN', '3', '掌支付-支付宝', NULL, '掌支付', 't',263, '3', NULL
WHERE not EXISTS(SELECT id FROM bank where id=140);

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
SELECT '141', 'zhangzhifu_wx', NULL, 'CN', '3', '掌支付-微信支付', NULL, '掌支付', 't', 262, '2', NULL
WHERE not EXISTS(SELECT id FROM bank where id=141);


INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use",  "order_num", "pay_type", "website")
SELECT '142', 'amx_zfb', NULL, 'CN', '3', '艾米森-支付宝', NULL, '艾米森', 't',13, '3', NULL
WHERE not EXISTS(SELECT id FROM bank where id=142);

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
SELECT '143', 'amx_wx', NULL, 'CN', '3', '艾米森-微信支付', NULL, '艾米森', 't', 12, '2', NULL
WHERE not EXISTS(SELECT id FROM bank where id=143);

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
SELECT '144', 'weixin_wx', NULL, 'CN', '3', '财付通-微信支付', NULL, '财付通', 't', 32, '2', NULL
WHERE not EXISTS(SELECT id FROM bank where id=144);

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use",  "order_num", "pay_type", "website")
SELECT '145', 'lexinfu_zfb', NULL, 'CN', '3', '乐信付-支付宝', NULL, '乐信付', 't',123, '3', NULL
WHERE not EXISTS(SELECT id FROM bank where id=145);

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
SELECT '146', 'lexinfu_wx', NULL, 'CN', '3', '乐信付-微信支付', NULL, '乐信付', 't', 122, '2', NULL
WHERE not EXISTS(SELECT id FROM bank where id=146);

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use","order_num", "pay_type", "website")
SELECT '147', 'lexinfu', NULL, 'CN', '3', '乐信付-网银', NULL, '乐信付', 't', 121, '1', NULL
WHERE not EXISTS(SELECT id FROM bank where id=147);