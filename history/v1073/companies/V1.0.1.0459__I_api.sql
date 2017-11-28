-- auto gen by george 2017-11-01 09:18:07
INSERT INTO "api" ("id", "status", "order_num", "maintain_start_time", "maintain_end_time", "code", "domain", "transferable", "terminal")
SELECT '21', 'normal', '21', NULL, NULL, '21', '', 't', '0'
WHERE not EXISTS (SELECT id FROM api where id=21);

INSERT INTO "api_i18n" ("name", "locale", "api_id", "logo1", "logo2", "cover", "introduce_status", "introduce_content")
SELECT '新皇冠体育', 'zh_CN', '21', '', '', '', 'normal', '新皇冠体育'
WHERE not EXISTS(SELECT id FROM api_i18n where api_id=21 and locale='zh_CN');

INSERT INTO "api_i18n" ("name", "locale", "api_id", "logo1", "logo2", "cover", "introduce_status", "introduce_content")
SELECT '新皇冠體育', 'en_US', '21', '', '', '', 'normal', '新皇冠体育'
WHERE not EXISTS(SELECT id FROM api_i18n where api_id=21 and locale='en_US');

INSERT INTO "api_i18n" ("name", "locale", "api_id", "logo1", "logo2", "cover", "introduce_status", "introduce_content")
SELECT '新皇冠體育', 'zh_TW', '21', '', '', '', 'normal', '新皇冠體育'
WHERE not EXISTS(SELECT id FROM api_i18n where api_id=21 and locale='zh_TW');

INSERT INTO "api_i18n" ("name", "locale", "api_id", "logo1", "logo2", "cover", "introduce_status", "introduce_content")
SELECT '新皇冠體育', 'ja_JP', '21', '', '', '', 'normal', '新皇冠體育'
WHERE not EXISTS(SELECT id FROM api_i18n where api_id=21 and locale='ja_JP');

INSERT INTO"api_type_relation" ("api_id", "api_type_id", "order_num", "rebate_order_num")
SELECT '21', '3', NULL, NULL
WHERE not EXISTS(SELECT id FROM api_type_relation WHERE api_id=21 and api_type_id=3);

INSERT INTO "api_type_relation_i18n" ("api_id", "api_type_id", "name", "local")
SELECT '21', '3', '新皇冠體育', 'en_US'
WHERE not EXISTS(SELECT id FROM api_type_relation_i18n WHERE api_id=21 and api_type_id=3 and local='en_US');

INSERT INTO "api_type_relation_i18n" ("api_id", "api_type_id", "name", "local")
SELECT '21', '3', '新皇冠體育', 'zh_TW'
WHERE not EXISTS(SELECT id FROM api_type_relation_i18n WHERE api_id=21 and api_type_id=3 and local='zh_TW');

INSERT INTO "api_type_relation_i18n" ("api_id", "api_type_id", "name", "local")
SELECT '21', '3', '新皇冠體育', 'ja_JP'
WHERE not EXISTS(SELECT id FROM api_type_relation_i18n WHERE api_id=21 and api_type_id=3 and local='ja_JP');

INSERT INTO "api_type_relation_i18n" ("api_id", "api_type_id", "name", "local")
SELECT '21', '3', '新皇冠体育', 'zh_CN'
WHERE not EXISTS(SELECT id FROM api_type_relation_i18n WHERE api_id=21 and api_type_id=3 and local='zh_CN');

INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json", "gametype")
SELECT '21', '0', now(), '0', now(), 'f', NULL, NULL, NULL, NULL
WHERE not EXISTS(SELECT id FROM api_order_log where api_id=21 and type='0');

INSERT INTO "api_gametype_relation" ("api_id", "game_type", "url", "parameter")
SELECT '21', 'SportsBook', '', ''
where not EXISTS (SELECT id FROM api_gametype_relation where api_id='21');