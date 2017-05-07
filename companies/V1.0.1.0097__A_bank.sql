-- auto gen by admin 2016-05-13 20:58:30

select redo_sqls($$
       ALTER TABLE bank ADD COLUMN pay_type character varying(1);
			COMMENT ON COLUMN bank.pay_type IS '线上支付类型1:银行直连，2微信支付，3支付宝支付';
$$);
UPDATE bank SET pay_type='1' WHERE "type"='3';

INSERT INTO "bank" ("id","bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use",  "order_num", "pay_type")
SELECT 45, 'mobao_wx', NULL, 'CN', '3', '魔宝-微信支付', NULL, '魔宝', 't',  NULL, 2
WHERE 'mobao_wx' not in (SELECT bank_name FROM bank WHERE bank_name='mobao_wx');

INSERT INTO "bank" ("id","bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type")
SELECT 46,'mobao_zfb', NULL, 'CN', '3', '魔宝-支付宝', NULL, '魔宝', 't',  NULL, 3
WHERE 'mobao_zfb' not in(SELECT bank_name FROM bank WHERE bank_name='mobao_zfb');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'content', 'pay_account_account_type', '3', '3', '微信支付', NULL, 't'
WHERE '3' not in(SELECT dict_code FROM sys_dict WHERE module='content' and dict_type='pay_account_account_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT 'content', 'pay_account_account_type', '4', '4', '支付宝支付', NULL, 't'
WHERE '3' not in(SELECT dict_code FROM sys_dict WHERE module='content' and dict_type='pay_account_account_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'mobao_wx', '30', '魔宝微信支付', NULL, 't'
WHERE 'mobao_wx' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'mobao_zfb', '31', '魔宝支付宝支付', NULL, 't'
WHERE 'mobao_zfb' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

