-- auto gen by tony 2015-12-30 14:25:30
delete from bank where "type" = '1';
UPDATE "bank" SET "id"='2', "bank_name"='alipay', "bank_icon"='/images/bank/thirdparty/alipay.png', "bank_district"='china', "type"='2', "bank_short_name"='支付宝', "bank_icon_simplify"='/images/bank/thirdparty/cbc.png', "bank_short_name2"=NULL, "is_use"='f' WHERE ("id"='2');
UPDATE "bank" SET "id"='3', "bank_name"='tenpay', "bank_icon"='/images/bank/thirdparty/tenpay.png', "bank_district"='china', "type"='2', "bank_short_name"='财付通', "bank_icon_simplify"='/images/bank/thirdparty/cbc.png', "bank_short_name2"=NULL, "is_use"='t' WHERE ("id"='3');

INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('11', 'ICBC', '/images/bank/ICBC.png', 'china', '1', '中国工商银行', '/images/bank/_ICBC.png', '工行', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('12', 'CCB', '/images/bank/CCB.png', 'china', '1', '中国建设银行', '/images/bank/_CCB.png', '建行', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('13', 'HSBC', '/images/bank/HSBC.png', 'china', '1', '汇丰银行', '/images/bank/_HSBC.png', '汇丰', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('14', 'BOC', '/images/bank/BOC.png', 'china', '1', '中国银行', '/images/bank/_BOC.png', '中行', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('15', 'ABC', '/images/bank/ABC.png', 'china', '1', '中国农业银行', '/images/bank/_ABC.png', '农行', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('16', 'boco', '/images/bank/BCM.png', 'china', '1', '交通银行', '/images/bank/_BCM.png', '交行', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('17', 'CMB', '/images/bank/CMB.png', 'china', '1', '招商银行 ', '/images/bank/_CMB.png', '招行', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('18', 'CNCB', '/images/bank/CNCB.png', 'china', '1', '中国民生银行', '/images/bank/_CNCB.png', '民生', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('19', 'SPDB', '/images/bank/SPDB.png', 'china', '1', '上海浦东发展银行', '/images/bank/_SPDB.png', '浦发', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('20', 'ecitic', '/images/bank/CITIC.png', 'china', '1', '中信银行', '/images/bank/_CITIC.png', '中信', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('21', 'cebb', '/images/bank/CEB.png', 'china', '1', '中国光大银行', '/images/bank/_CEB.png', '光大', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('22', 'hxb', '/images/bank/HB.png', 'china', '1', '华夏银行', '/images/bank/_HB.png', '华夏', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('23', 'GDB', '/images/bank/GDB.png', 'china', '1', '广东发展银行', '/images/bank/_GDB.png', '广发', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('24', 'SDB', '/images/bank/SDB.png', 'china', '1', '深圳发展银行', '/images/bank/_SDB.png', '深发', 't');
INSERT INTO "bank" ("id", "bank_name", "bank_icon", "bank_district", "type", "bank_short_name", "bank_icon_simplify", "bank_short_name2", "is_use") VALUES ('25', 'CIB', '/images/bank/CIB.png', 'china', '1', '兴业银行', '/images/bank/_CIB.png', '兴业', 't');

UPDATE "bank_extend" SET "id"='1', "bank_card_begin"='6227', "bank_name"='CCB' WHERE ("id"='1');
UPDATE "bank_extend" SET "id"='2', "bank_card_begin"='6219', "bank_name"='CMB' WHERE ("id"='2');
UPDATE "bank_extend" SET "id"='3', "bank_card_begin"='6221', "bank_name"='ICBC' WHERE ("id"='3');

INSERT INTO "bank_extend" ("id", "bank_card_begin", "bank_name") SELECT '4', '436742', 'CCB' WHERE NOT EXISTS (SELECT id from bank_extend where id=4);
INSERT INTO "bank_extend" ("id", "bank_card_begin", "bank_name") SELECT '5', '622280', 'CCB' WHERE NOT EXISTS (SELECT id from bank_extend where id=5);
INSERT INTO "bank_extend" ("id", "bank_card_begin", "bank_name") SELECT '6', '458123', 'BOCM' WHERE NOT EXISTS (SELECT id from bank_extend where id=6);

UPDATE "bank_support_currency" SET "id"='2', "bank_code"='ICBC', "currency_name"='工商银行', "currency_code"='CNY' WHERE ("id"='2');
UPDATE "bank_support_currency" SET "id"='3', "bank_code"='ICBC', "currency_name"='工商银行', "currency_code"='USD' WHERE ("id"='3');
UPDATE "bank_support_currency" SET "id"='4', "bank_code"='CCB', "currency_name"='建设银行', "currency_code"='USD' WHERE ("id"='4');
UPDATE "bank_support_currency" SET "id"='5', "bank_code"='CMB', "currency_name"='招商银行', "currency_code"='CNY' WHERE ("id"='5');

