-- auto gen by cherry 2017-06-08 11:38:19
INSERT INTO"api_type_relation" ("api_id", "api_type_id", "order_num", "rebate_order_num")
SELECT '23', '3', NULL, NULL
WHERE not EXISTS(SELECT id FROM api_type_relation WHERE api_id=23 and api_type_id=3);

INSERT INTO"api_type_relation" ("api_id", "api_type_id", "order_num", "rebate_order_num")
SELECT '24', '1', NULL, NULL
WHERE not EXISTS(SELECT id FROM api_type_relation WHERE api_id=24 and api_type_id=1);


INSERT INTO "api_type_relation_i18n" ("api_id", "api_type_id", "name", "local")
SELECT '24', '1', 'OPUSCASINO', 'en_US'
WHERE not EXISTS(SELECT id FROM api_type_relation_i18n WHERE api_id=24 and api_type_id=1 and local='en_US');

INSERT INTO "api_type_relation_i18n" ("api_id", "api_type_id", "name", "local")
SELECT '24', '1', '歐普斯真人', 'zh_TW'
WHERE not EXISTS(SELECT id FROM api_type_relation_i18n WHERE api_id=24 and api_type_id=1 and local='zh_TW');

INSERT INTO "api_type_relation_i18n" ("api_id", "api_type_id", "name", "local")
SELECT '24', '1', '欧普斯真人', 'zh_CN'
WHERE not EXISTS(SELECT id FROM api_type_relation_i18n WHERE api_id=24 and api_type_id=1 and local='zh_CN');

INSERT INTO "api_type_relation_i18n" ("api_id", "api_type_id", "name", "local")
SELECT '23', '3', 'OPUSSPORT', 'en_US'
WHERE not EXISTS(SELECT id FROM api_type_relation_i18n WHERE api_id=23 and api_type_id=3 and local='en_US');

INSERT INTO "api_type_relation_i18n" ("api_id", "api_type_id", "name", "local")
SELECT '23', '3', '歐普斯體育', 'zh_TW'
WHERE not EXISTS(SELECT id FROM api_type_relation_i18n WHERE api_id=23 and api_type_id=3 and local='zh_TW');

INSERT INTO "api_type_relation_i18n" ("api_id", "api_type_id", "name", "local")
SELECT '23', '3', '欧普斯体育', 'zh_CN'
WHERE not EXISTS(SELECT id FROM api_type_relation_i18n WHERE api_id=23 and api_type_id=3 and local='zh_CN');



