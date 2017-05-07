-- auto gen by cherry 2016-08-26 09:43:57
--添加一个其它的银行 支持货币已有
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
SELECT '59', 'other', NULL, 'CN', '1', ' 其它银行', NULL, ' 其它银行', 't', '28', NULL, NULL
WHERE not EXISTS(select id FROM bank where id=59);

update bank set order_num = 27 where bank_name='tzb';