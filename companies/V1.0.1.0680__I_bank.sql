-- auto gen by linsen 2018-08-30 16:28:18
-- 添加吉林银行和青岛银行
INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
SELECT   'jlbank', '', 'CN', '1', '吉林银行', '', '吉林银行', 't', '', '28', '', 'http://www.jlbank.com.cn'
WHERE NOT EXISTS (SELECT ID FROM bank WHERE bank_name='jlbank');

INSERT INTO "bank" ("bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "__clean__", "order_num", "pay_type", "website")
SELECT   'qdbank', '', 'CN', '1', '青岛银行', '', '青岛银行', 't', '', '29', '', 'http://www.qdccb.com'
WHERE NOT EXISTS (SELECT ID FROM bank WHERE bank_name='qdbank');

UPDATE bank SET order_num='30' WHERE bank_name ='other_bank';


-- 添加吉林银行和青岛银行
INSERT INTO "bank_support_currency" ("bank_code", "currency_name", "currency_code")
SELECT 'jlbank', '吉林银行', 'CNY'
WHERE not EXISTS(SELECT id FROM bank_support_currency where bank_code='jlbank');

INSERT INTO "bank_support_currency" ("bank_code", "currency_name", "currency_code")
SELECT 'qdbank', '青岛银行', 'CNY'
WHERE not EXISTS(SELECT id FROM bank_support_currency where bank_code='qdbank');
