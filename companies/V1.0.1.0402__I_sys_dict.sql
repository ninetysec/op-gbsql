-- auto gen by cherry 2017-08-25 21:58:21
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'fund_type', 'bitcoin_fast', '19', '资金类型：比特币支付', NULL, 't'
WHERE not EXISTS (SELECT id FROM sys_dict WHERE module='common' and dict_type='fund_type' and dict_code='bitcoin_fast');
