-- auto gen by cherry 2017-07-15 17:54:34
INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'lottery', 'ahk3', '5', '安徽快3', NULL, 't' WHERE NOT EXISTS (SELECT dict_code from sys_dict where module='lottery' and dict_type='lottery' and dict_code='ahk3');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'lottery', 'gxk3', '6', '广西快3', NULL, 't' WHERE NOT EXISTS (SELECT dict_code from sys_dict where module='lottery' and dict_type='lottery' and dict_code='gxk3');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'lottery', 'hbk3', '7', '湖北快3', NULL, 't' WHERE NOT EXISTS (SELECT dict_code from sys_dict where module='lottery' and dict_type='lottery' and dict_code='hbk3');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'lottery', 'tjssc', '8', '天津时时彩', NULL, 't' WHERE NOT EXISTS (SELECT dict_code from sys_dict where module='lottery' and dict_type='lottery' and dict_code='tjssc');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'lottery', 'lottery', 'xjssc', '9', '新疆时时彩', NULL, 't' WHERE NOT EXISTS (SELECT dict_code from sys_dict where module='lottery' and dict_type='lottery' and dict_code='xjssc');

INSERT INTO  "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
 SELECT  'common', 'fund_type', 'qqwallet_scan', '18', '资金类型：QQ钱包扫码支付', NULL, 't'
 WHERE  NOT EXISTS (select "dict_code","module","dict_type" from sys_dict where "dict_code" = 'qqwallet_scan' and "module"='common' and "dict_type"='fund_type');