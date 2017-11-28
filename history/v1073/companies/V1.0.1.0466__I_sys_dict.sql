-- auto gen by cherry 2017-11-09 09:33:16
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'fund_type', 'onecodepay_fast', '21', '公司入款：一码付电子支付', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_code='onecodepay_fast' AND dict_type='fund_type');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'fund_type', 'qqwallet_fast', '22', '公司入款：QQ钱包电子支付', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_code='qqwallet_fast' AND dict_type='fund_type');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'fund_type', 'bdwallet_fast', '23', '公司入款：百度钱包电子支付', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_code='bdwallet_fast' AND dict_type='fund_type');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'fund_type', 'jdpay_scan', '24', '线上支付：京东扫码支付', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_code='jdpay_scan' AND dict_type='fund_type');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'fund_type', 'jdwallet_fast', '25', '公司入款：京东钱包电子支付', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_code='jdwallet_fast' AND dict_type='fund_type');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'fund_type', 'bdwallet_san', '26', '线上支付：百度扫码支付', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_code='bdwallet_san' AND dict_type='fund_type');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'fund_type', 'union_pay_scan', '27', '线上支付：银联扫码支付', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_code='union_pay_scan' AND dict_type='fund_type');



INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'transaction_way', 'onecodepay_fast', '21', '公司入款：一码付电子支付', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_code='onecodepay_fast' AND dict_type='transaction_way');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'transaction_way', 'qqwallet_fast', '22', '公司入款：QQ钱包电子支付', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_code='qqwallet_fast' AND dict_type='transaction_way');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'transaction_way', 'bdwallet_fast', '23', '公司入款：百度钱包电子支付', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_code='bdwallet_fast' AND dict_type='transaction_way');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'transaction_way', 'jdpay_scan', '24', '线上支付：京东扫码支付', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_code='jdpay_scan' AND dict_type='transaction_way');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'transaction_way', 'jdwallet_fast', '25', '公司入款：京东钱包电子支付', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_code='jdwallet_fast' AND dict_type='transaction_way');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'transaction_way', 'bdwallet_san', '26', '线上支付：百度扫码支付', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_code='bdwallet_san' AND dict_type='transaction_way');


INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'transaction_way', 'union_pay_scan', '27', '线上支付：银联扫码支付', NULL, 't'
WHERE NOT EXISTS(SELECT ID FROM sys_dict WHERE dict_code='union_pay_scan' AND dict_type='transaction_way');