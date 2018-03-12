-- auto gen by cherry 2018-02-26 20:07:12
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'fund_type', 'easy_pay', '28', '线上支付：易收付', NULL, 't'
WHERE not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type='fund_type' AND dict_code='easy_pay');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'transaction_way', 'easy_pay', '28', '线上支付：易收付', NULL, 't'
WHERE not EXISTS (SELECT id FROM sys_dict where module='common' and dict_type='transaction_way' AND dict_code='easy_pay');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'fund', 'recharge_type', 'easy_pay', '17', '线上支付：易收付', 'online_deposit', 't'
WHERE not EXISTS (SELECT id FROM sys_dict where module='fund' and dict_type='recharge_type' AND dict_code='easy_pay');