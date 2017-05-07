-- auto gen by cherry 2017-02-28 09:16:10
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use",  "order_num", "pay_type", "website")
SELECT '102', 'rongepay_zfb', NULL, 'CN', '3', '融e付-支付宝', NULL, '融e付', 't',318, '3', NULL
WHERE not EXISTS(SELECT id FROM bank where id=102);

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
SELECT '103', 'rongepay_wx', NULL, 'CN', '3', '融e付-微信支付', NULL, '融e付', 't', 218, '2', NULL
WHERE not EXISTS(SELECT id FROM bank where id=103);


INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
SELECT '107', 'jiupay_zfb', NULL, 'CN', '3', '久付-支付宝', NULL, '久付', 't', '310', '3', NULL
WHERE not EXISTS(SELECT id FROM bank where id=107);

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '104', 'hfb', NULL, 'CN', '3', '惠付宝-网银', NULL, '惠付宝', 't', 108, '1', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='hfb');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '105', 'hfb_wx', NULL, 'CN', '3', '惠付宝-微信支付', NULL, '惠付宝', 't', 208, '2', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='hfb_wx');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
  SELECT '106', 'hfb_zfb', NULL, 'CN', '3', '惠付宝-支付宝', NULL, '惠付宝', 't', 308, '3', NULL
  WHERE not EXISTS(SELECT id FROM bank where bank_name='hfb_zfb');