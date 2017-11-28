-- auto gen by admin 2016-04-10 20:50:06
DELETE FROM sys_dict WHERE "module"='common' AND dict_type='bankname';

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'alipay', '1', '支付宝', NULL, 't'
WHERE 'alipay' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'tenpay', '2', '财付通', NULL, 't'
WHERE 'tenpay' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'baofoo', '3', '宝付支付', NULL, 't'
WHERE 'baofoo' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'gopay', '4', '国付宝', NULL, 't'
WHERE 'gopay' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'ips_3', '5', '环迅支付3.0', NULL, 't'
WHERE 'ips_3' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'yeepay', '6', '易宝支付', NULL, 't'
WHERE 'yeepay' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'icbc', '7', '中国工商银行', NULL, 't'
WHERE 'icbc' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'ccb', '8', '中国建设银行', NULL, 't'
WHERE 'ccb' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'hsbc', '1', '汇丰银行', NULL, 't'
WHERE 'hsbc' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'boc', '9', '中国银行', NULL, 't'
WHERE 'boc' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'abc', '10', '中国农业银行', NULL, 't'
WHERE 'abc' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'boco', '11', '交通银行', NULL, 't'
WHERE 'boco' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'cmb', '12', '招商银行', NULL, 't'
WHERE 'cmb' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'cncb', '13', '中国民生银行', NULL, 't'
WHERE 'cncb' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'spdb', '14', '上海浦东发展银行', NULL, 't'
WHERE 'spdb' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'ecitic', '15', '中信银行', NULL, 't'
WHERE 'ecitic' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'cebb', '16', '中国光大银行', NULL, 't'
WHERE 'cebb' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'hxb', '17', '华夏银行', NULL, 't'
WHERE 'hxb' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'gdb', '18', '广东发展银行', NULL, 't'
WHERE 'gdb' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'sdb', '19', '深圳发展银行', NULL, 't'
WHERE 'sdb' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'cib', '20', '兴业银行', NULL, 't'
WHERE 'cib' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'reapal', '21', '融宝', NULL, 't'
WHERE 'reapal' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'bbpay_old', '22', '币币支付老平台', NULL, 't'
WHERE 'bbpay_old' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'bbpay_new', '23', '币币支付新平台', NULL, 't'
WHERE 'bbpay_new' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'bbpay_new', '24', '币币支付新平台', NULL, 't'
WHERE 'bbpay_new' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'dinpay', '25', '快汇宝', NULL, 't'
WHERE 'dinpay' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'ecpss', '26', '汇潮支付', NULL, 't'
WHERE 'ecpss' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'kjt', '27', '快捷通', NULL, 't'
WHERE 'kjt' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'mobao', '28', '摩宝', NULL, 't'
WHERE 'mobao' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'ips_7', '29', '环迅支付7.0', NULL, 't'
WHERE 'ips_7' not in (SELECT dict_code FROM sys_dict WHERE module='common' and dict_type='bankname');

DELETE FROM bank;
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('29', 'ips_7', NULL, 'CN', '3', '环迅支付7.0', NULL, NULL, 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('28', 'mobao', NULL, 'CN', '3', '摩宝', NULL, NULL, 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('27', 'kjt', NULL, 'CN', '3', '快捷通', NULL, NULL, 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('26', 'ecpss', NULL, 'CN', '3', '汇潮支付', NULL, NULL, 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('25', 'dinpay', NULL, 'CN', '3', '快汇宝', NULL, NULL, 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('24', 'bbpay_new', NULL, 'CN', '3', '币币支付新平台', NULL, NULL, 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('23', 'bbpay_old', NULL, 'CN', '3', '币币支付老平台', NULL, NULL, 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('22', 'reapal', '', 'CN', '3', '融宝', '', '', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('21', 'cib', '/images/bank/CIB.png', 'CN', '1', '兴业银行', '/images/bank/_CIB.png', '兴业', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('20', 'sdb', '/images/bank/SDB.png', 'CN', '1', '深圳发展银行', '/images/bank/_SDB.png', '深发', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('19', 'gdb', '/images/bank/GDB.png', 'CN', '1', '广东发展银行', '/images/bank/_GDB.png', '广发', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('18', 'hxb', '/images/bank/HB.png', 'CN', '1', '华夏银行', '/images/bank/_HB.png', '华夏', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('17', 'cebb', '/images/bank/CEB.png', 'CN', '1', '中国光大银行', '/images/bank/_CEB.png', '光大', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('16', 'ecitic', '/images/bank/CITIC.png', 'CN', '1', '中信银行', '/images/bank/_CITIC.png', '中信', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('15', 'spdb', '/images/bank/SPDB.png', 'CN', '1', '上海浦东发展银行', '/images/bank/_SPDB.png', '上海浦东', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('14', 'cncb', '/images/bank/CNCB.png', 'CN', '1', '中国民生银行', '/images/bank/_CNCB.png', '民生', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('13', 'cmb', '/images/bank/CMB.png', 'CN', '1', '招商银行 ', '/images/bank/_CMB.png', '招行', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('12', 'boco', '/images/bank/BCM.png', 'CN', '1', '交通银行', '/images/bank/_BCM.png', '交通', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('11', 'abc', '/images/bank/ABC.png', 'CN', '1', '中国农业银行', '/images/bank/_ABC.png', '农业银行', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('10', 'boc', '/images/bank/BOC.png', 'CN', '1', '中国银行', '/images/bank/_BOC.png', '中国银行', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('9', 'hsbc', '/images/bank/HSBC.png', 'CN', '1', '汇丰银行', '/images/bank/_HSBC.png', '汇丰', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('8', 'ccb', '/images/bank/CCB.png', 'CN', '1', '中国建设银行', '/images/bank/_CCB.png', '建设', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('7', 'icbc', '/images/bank/ICBC.png', 'CN', '1', '中国工商银行', '/images/bank/_ICBC.png', '工商', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('6', 'yeepay', '', 'CN', '3', '易宝付', '', '', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('5', 'ips_3', '', 'CN', '3', '环迅支付3.0', '', '', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('4', 'gopay', '', 'CN', '3', '国付宝', '', '', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('3', 'baofoo', '', 'CN', '3', '宝付', '', '', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('2', 'tenpay', '/images/bank/thirdparty/tenpay.png', 'CN', '2', '财付通', '/images/bank/thirdparty/cbc.png', '财付通', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('1', 'alipay', '/images/bank/thirdparty/alipay.png', 'CN', '2', '支付宝', '/images/bank/thirdparty/cbc.png', '支付宝', 'f');


