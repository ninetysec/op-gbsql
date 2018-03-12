-- auto gen by linsen 2018-03-12 10:19:10

--久通 by Leo
INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'jiutong', NULL, 'CN', '3', '久通-网银', NULL, '久通', 't', '101', '1', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='jiutong');

--天逸付 by Leo
INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'tianyifu_jd', NULL, 'CN', '3', '天逸付-京东钱包', NULL, '天逸付', 't', '205', '5', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='tianyifu_jd');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'tianyifu_qq', NULL, 'CN', '3', '天逸付-QQ钱包', NULL, '天逸付', 't', '204', '4', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='tianyifu_qq');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'tianyifu_zfbwap', NULL, 'CN', '3', '天逸付-支付宝WAP', NULL, '天逸付', 't', '203', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='tianyifu_zfbwap');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'tianyifu_zfbh5', NULL, 'CN', '3', '天逸付-支付宝H5', NULL, '天逸付', 't', '203', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='tianyifu_zfbh5');

--先疯 by Leo
INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'xianfeng', NULL, 'CN', '3', '先疯-网银', NULL, '先疯', 't', '241', '1', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='xianfeng');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'xianfeng_wyh5', NULL, 'CN', '3', '先疯-网银H5', NULL, '先疯', 't', '241', '1', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='xianfeng_wyh5');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'xianfeng_jd', NULL, 'CN', '3', '先疯-京东钱包', NULL, '先疯', 't', '245', '5', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='xianfeng_jd');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'xianfeng_yl', NULL, 'CN', '3', '先疯-银联扫码', NULL, '先疯', 't', '247', '7', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='xianfeng_yl');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'xianfeng_ylh5', NULL, 'CN', '3', '先疯-银联扫码H5', NULL, '先疯', 't', '247', '7', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='xianfeng_ylh5');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'xianfeng_wxh5', NULL, 'CN', '3', '先疯-微信H5', NULL, '先疯', 't', '242', '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='xianfeng_wxh5');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'xianfeng_qq', NULL, 'CN', '3', '先疯-QQ钱包', NULL, '先疯', 't', '244', '4', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='xianfeng_qq');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'xianfeng_zfb', NULL, 'CN', '3', '先疯-支付宝', NULL, '先疯', 't', '243', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='xianfeng_zfb');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'xianfeng_zfbh5', NULL, 'CN', '3', '先疯-支付宝H5', NULL, '先疯', 't', '243', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='xianfeng_zfbh5');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'xianfeng_wx', NULL, 'CN', '3', '先疯-微信', NULL, '先疯', 't', '242', '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='xianfeng_wx');

--易达 by Leo
INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'yida', NULL, 'CN', '3', '易达-网银', NULL, '易达', 't', '251', '1', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='yida');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'yida_qq', NULL, 'CN', '3', '易达-QQ钱包', NULL, '易达', 't', '254', '4', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='yida_qq');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'yida_qqwap', NULL, 'CN', '3', '易达-QQ钱包WAP', NULL, '易达', 't', '254', '4', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='yida_qqwap');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'yida_kj', NULL, 'CN', '3', '易达-网银快捷', NULL, '易达', 't', '251', '1', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='yida_kj');

--游久 by Leo
INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'youjiu_qqh5', NULL, 'CN', '3', '游久-QQ钱包H5', NULL, '游久', 't', '254', '4', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='youjiu_qqh5');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'youjiu_qq', NULL, 'CN', '3', '游久-QQ钱包', NULL, '游久', 't', '254', '4', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='youjiu_qq');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'youjiu_zfb', NULL, 'CN', '3', '游久-支付宝', NULL, '游久', 't', '253', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='youjiu_zfb');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'youjiu_zfbh5', NULL, 'CN', '3', '游久-支付宝H5', NULL, '游久', 't', '253', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='youjiu_zfbh5');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'youjiu_wx', NULL, 'CN', '3', '游久-微信', NULL, '游久', 't', '252', '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='youjiu_wx');

--优米付 by snake
INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'youmifu', NULL, 'CN', '3', '优米付-网银', NULL, '优米付', 't', '251', '1', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='youmifu');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'youmifu_wxh5', NULL, 'CN', '3', '优米付-微信H5', NULL, '优米付', 't', '252', '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='youmifu_wxh5');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'youmifu_wxwap', NULL, 'CN', '3', '优米付-微信WAP', NULL, '优米付', 't', '252', '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='youmifu_wxwap');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'youmifu_zfbh5', NULL, 'CN', '3', '优米付-支付宝H5', NULL, '优米付', 't', '253', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='youmifu_zfbh5');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'youmifu_zfbwap', NULL, 'CN', '3', '优米付-支付宝WAP', NULL, '优米付', 't', '253', '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='youmifu_zfbwap');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'youmifu_qqh5', NULL, 'CN', '3', '优米付-QQ钱包H5', NULL, '优米付', 't', '254', '4', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='youmifu_qqh5');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'youmifu_qqwap', NULL, 'CN', '3', '优米付-QQ钱包WAP', NULL, '优米付', 't', '254', '4', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='youmifu_qqwap');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'youmifu_jdh5', NULL, 'CN', '3', '优米付-京东钱包H5', NULL, '优米付', 't', '255', '5', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='youmifu_jdh5');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'youmifu_yl', NULL, 'CN', '3', '优米付-银联扫码', NULL, '优米付', 't', '257', '7', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='youmifu_yl');

--亿起付 by holeter
INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT 'yiqifu', NULL, 'CN', '3', '亿起付-网银', NULL, '亿起付', 't','251', '1', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='yiqifu');
