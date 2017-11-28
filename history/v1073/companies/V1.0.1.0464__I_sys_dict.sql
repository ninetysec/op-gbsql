-- auto gen by george 2017-11-03 14:26:58
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT  'fund', 'recharge_type', 'qqwallet_fast', '8', '公司入款:QQ钱包电子支付', 'company_deposit', 't'
 WHERE  NOT EXISTS (select "dict_code","module","dict_type" from sys_dict where "dict_code" = 'qqwallet_fast' and "module"='fund' and "dict_type"='recharge_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT  'fund', 'recharge_type', 'jdwallet_fast', '9', '公司入款:京东钱包电子支付', 'company_deposit', 't'
 WHERE  NOT EXISTS (select "dict_code","module","dict_type" from sys_dict where "dict_code" = 'jdwallet_fast' and "module"='fund' and "dict_type"='recharge_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT  'fund', 'recharge_type', 'bdwallet_fast', '10', '公司入款:百度钱包电子支付', 'company_deposit', 't'
 WHERE  NOT EXISTS (select "dict_code","module","dict_type" from sys_dict where "dict_code" = 'bdwallet_fast' and "module"='fund' and "dict_type"='recharge_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT  'fund', 'recharge_type', 'onecodepay_fast', '11', '公司入款:一码付电子支付', 'company_deposit', 't'
 WHERE  NOT EXISTS (select "dict_code","module","dict_type" from sys_dict where "dict_code" = 'onecodepay_fast' and "module"='fund' and "dict_type"='recharge_type');