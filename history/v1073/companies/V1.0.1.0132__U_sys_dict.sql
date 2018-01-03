-- auto gen by cherry 2016-07-20 21:49:25
UPDATE bank SET bank_short_name='智付（快汇宝）' , bank_short_name2='智付（快汇宝）' WHERE bank_name='dinpay';

UPDATE sys_dict set remark='' where "module"='common' AND dict_type='bankname' AND dict_code='dinpay' ;

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'spabank', '30', '平安银行', NULL, 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='common' and dict_type='bankname' and dict_code='spabank');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'bjbank', '31', '北京银行', NULL, 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='common' and dict_type='bankname' and dict_code='bjbank');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'psbc', '32', '中国邮政储蓄银行', NULL, 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='common' and dict_type='bankname' and dict_code='psbc');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'jsbank', '33', '江苏银行', NULL, 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='common' and dict_type='bankname' and dict_code='jsbank');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'shbank', '34', '上海银行', NULL, 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='common' and dict_type='bankname' and dict_code='shbank');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'bohaib', '35', '渤海银行', NULL, 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='common' and dict_type='bankname' and dict_code='bohaib');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'hkbea', '36', '东亚银行', NULL, 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='common' and dict_type='bankname' and dict_code='hkbea');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'nbbank', '37', '宁波银行', NULL, 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='common' and dict_type='bankname' and dict_code='nbbank');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'czbank', '38', '浙商银行', NULL, 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='common' and dict_type='bankname' and dict_code='czbank');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'hzcb', '39', '杭州银行', NULL, 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='common' and dict_type='bankname' and dict_code='hzcb');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'gcb', '40', '广州银行', NULL, 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='common' and dict_type='bankname' and dict_code='gcb');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'fjnx', '41', '福建农商银行', NULL, 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='common' and dict_type='bankname' and dict_code='fjnx');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'hangseng', '42', '恒生银行', NULL, 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='common' and dict_type='bankname' and dict_code='hangseng');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'wechatpay', '43', '微信支付', NULL, 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='common' and dict_type='bankname' and dict_code='wechatpay');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'other', '44', '其它', NULL, 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='common' and dict_type='bankname' and dict_code='other');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'dinpay_wx', '45', '智付-微信支付', NULL, 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='common' and dict_type='bankname' and dict_code='dinpay_wx');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'sfoo', '46', '闪付', NULL, 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='common' and dict_type='bankname' and dict_code='sfoo');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'sfoo_wx', '47', '闪付-微信支付', NULL, 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='common' and dict_type='bankname' and dict_code='sfoo_wx');

INSERT INTO "sys_dict" ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'common', 'bankname', 'sfoo_zfb', '48', '闪付-支付宝', NULL, 't'
WHERE not EXISTS(SELECT dict_code from sys_dict where module='common' and dict_type='bankname' and dict_code='sfoo_zfb');

insert into sys_dict(module, dict_type, dict_code, order_num, remark, parent_code, active)

  SELECT 'content', 'float_pic_link_type', 'close_btn', '3', '关闭按钮', NULL, 't'

  WHERE NOT EXISTS (select dict_code from sys_dict t where t.dict_code = 'close_btn' and dict_type='float_pic_link_type');


update help_type_i18n set name = '在线支付' where help_type_id = 8;

update help_type_i18n set name = '网银存款' where help_type_id = 9;

update help_type_i18n set name = '扫码支付' where help_type_id = 10;

INSERT INTO "help_type" ("id", "is_delete", "parent_id", "order_num")

select '62', 'f', '1', '4' WHERE NOT EXISTS (select id from help_type where id = 62) ;

INSERT INTO "help_type" ("id", "is_delete", "parent_id", "order_num")

select '63', 'f', '1', '5' WHERE NOT EXISTS (select id from help_type where id = 63);



INSERT INTO "help_type_i18n" ("id", "help_type_id", "name", "local")

select '184', '62', '电子支付', 'zh_CN' WHERE NOT EXISTS (select id from  help_type_i18n where id = 184);

INSERT INTO "help_type_i18n" ("id", "help_type_id", "name", "local")

select '185', '62', '电子支付', 'zh_TW' WHERE NOT EXISTS (select id from  help_type_i18n where id = 185);

INSERT INTO "help_type_i18n" ("id", "help_type_id", "name", "local")

select '186', '62', '电子支付', 'en_US' WHERE NOT EXISTS (select id from  help_type_i18n where id = 186);



INSERT INTO "help_type_i18n" ("id", "help_type_id", "name", "local")

select '187', '63', '柜员机/柜台存款', 'zh_CN' WHERE NOT EXISTS (select id from  help_type_i18n where id = 187);

INSERT INTO "help_type_i18n" ("id", "help_type_id", "name", "local")

select '188', '63', '柜员机/柜台存款', 'zh_TW' WHERE NOT EXISTS (select id from  help_type_i18n where id = 188);

INSERT INTO "help_type_i18n" ("id", "help_type_id", "name", "local")

select '189', '63', '柜员机/柜台存款', 'en_US' WHERE NOT EXISTS (select id from  help_type_i18n where id = 189);


INSERT INTO  "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use",  "order_num", "pay_type", "website")
SELECT '48', 'sfoo', NULL, 'CN', '3', '闪付', NULL, '闪付', 't','48', '1', NULL
WHERE NOT EXISTS (SELECT bank_name  FROM bank where bank_name='sfoo');

INSERT INTO  "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use", "order_num", "pay_type", "website")
SELECT '49', 'sfoo_wx', NULL, 'CN', '3', '闪付-微信支付', NULL, '闪付', 't',NULL, '2', NULL
WHERE NOT EXISTS (SELECT bank_name  FROM bank where bank_name='sfoo_wx');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use","order_num", "pay_type", "website")
SELECT '50', 'sfoo_zfb', NULL, 'CN', '3', '闪付-支付宝', NULL, '闪付', 't', NULL, '3', NULL
WHERE NOT EXISTS (SELECT bank_name  FROM bank where bank_name='sfoo_zfb');