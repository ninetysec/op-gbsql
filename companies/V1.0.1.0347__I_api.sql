-- auto gen by cherry 2017-07-04 19:59:58

INSERT INTO "api" ("id", "status", "order_num", "maintain_start_time", "maintain_end_time", "code", "domain", "transferable", "terminal")
SELECT '25', 'normal', '25', NULL, NULL, '25', '', 't', '0'
WHERE not EXISTS (SELECT id FROM api where id=25);

INSERT INTO "api_i18n" ("name", "locale", "api_id", "logo1", "logo2", "cover", "introduce_status", "introduce_content")
SELECT '新霸电子', 'zh_CN', '25', '', '', '', 'normal', '新霸电子'
WHERE not EXISTS(SELECT id FROM api_i18n where api_id=25 and locale='zh_CN');

INSERT INTO "api_i18n" ("name", "locale", "api_id", "logo1", "logo2", "cover", "introduce_status", "introduce_content")
SELECT 'SPADE', 'en_US', '25', '', '', '', 'normal', '新霸电子'
WHERE not EXISTS(SELECT id FROM api_i18n where api_id=25 and locale='en_US');

INSERT INTO "api_i18n" ("name", "locale", "api_id", "logo1", "logo2", "cover", "introduce_status", "introduce_content")
SELECT '新霸電子', 'zh_TW', '25', '', '', '', 'normal', '新霸电子'
WHERE not EXISTS(SELECT id FROM api_i18n where api_id=25 and locale='zh_TW');

INSERT INTO"api_type_relation" ("api_id", "api_type_id", "order_num", "rebate_order_num")
SELECT '25', '2', NULL, NULL
WHERE not EXISTS(SELECT id FROM api_type_relation WHERE api_id=25 and api_type_id=2);


INSERT INTO "api_type_relation_i18n" ("api_id", "api_type_id", "name", "local")
SELECT '25', '2', 'SPADE', 'en_US'
WHERE not EXISTS(SELECT id FROM api_type_relation_i18n WHERE api_id=25 and api_type_id=2 and local='en_US');

INSERT INTO "api_type_relation_i18n" ("api_id", "api_type_id", "name", "local")
SELECT '25', '2', '新霸電子', 'zh_TW'
WHERE not EXISTS(SELECT id FROM api_type_relation_i18n WHERE api_id=25 and api_type_id=2 and local='zh_TW');

INSERT INTO "api_type_relation_i18n" ("api_id", "api_type_id", "name", "local")
SELECT '25', '2', '新霸电子', 'zh_CN'
WHERE not EXISTS(SELECT id FROM api_type_relation_i18n WHERE api_id=25 and api_type_id=2 and local='zh_CN');

INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json", "gametype")
SELECT '25', '0', now(), '0', now(), 'f', NULL, NULL, NULL, NULL
WHERE not EXISTS(SELECT id FROM api_order_log where api_id=25 and type='0');
