-- auto gen by bruce 2016-08-14 21:47:30
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT 53, 'tonghui', NULL, 'CN', '3', '通汇支付', NULL, '通汇', 't', '', NULL, '1', NULL WHERE 53 NOT IN(SELECT id FROM bank WHERE id=53);
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
  SELECT 54, 'tzb', '', 'CN', '1', '台州银行', '', '台州银行', 't', '', NULL, '', 'http://www.tzbank.com/' WHERE 54 NOT IN(SELECT id FROM bank WHERE id=54);