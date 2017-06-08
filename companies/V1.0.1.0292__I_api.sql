-- auto gen by cherry 2017-06-08 10:06:02
INSERT INTO "api" ("id", "status", "order_num", "maintain_start_time", "maintain_end_time", "code", "domain", "transferable", "terminal")
SELECT '23', 'normal', '23', NULL, NULL, '23', '', 't', '0'
WHERE not EXISTS (SELECT id FROM api where id=23);

INSERT INTO "api" ("id", "status", "order_num", "maintain_start_time", "maintain_end_time", "code", "domain", "transferable", "terminal")
SELECT '24', 'normal', '24', NULL, NULL, '24', '', 't', '0'
WHERE not EXISTS (SELECT id FROM api where id=24);

INSERT INTO "api_i18n" ("name", "locale", "api_id", "logo1", "logo2", "cover", "introduce_status", "introduce_content")
SELECT '欧普斯真人', 'zh_CN', '24', '', '', '', 'normal', '欧普斯真人'
WHERE not EXISTS(SELECT id FROM api_i18n where api_id=24 and locale='zh_CN');

INSERT INTO "api_i18n" ("name", "locale", "api_id", "logo1", "logo2", "cover", "introduce_status", "introduce_content")
SELECT 'OPUSCASINO', 'en_US', '24', '', '', '', 'normal', '欧普斯真人'
WHERE not EXISTS(SELECT id FROM api_i18n where api_id=24 and locale='en_US');

INSERT INTO "api_i18n" ("name", "locale", "api_id", "logo1", "logo2", "cover", "introduce_status", "introduce_content")
SELECT '歐普斯真人', 'zh_TW', '24', '', '', '', 'normal', '欧普斯真人'
WHERE not EXISTS(SELECT id FROM api_i18n where api_id=24 and locale='zh_TW');

INSERT INTO "api_i18n" ("name", "locale", "api_id", "logo1", "logo2", "cover", "introduce_status", "introduce_content")
SELECT '欧普斯体育', 'zh_CN', '23', '', '', '', 'normal', ''
WHERE not EXISTS(SELECT id FROM api_i18n where api_id=23 and locale='zh_CN');

INSERT INTO "api_i18n" ("name", "locale", "api_id", "logo1", "logo2", "cover", "introduce_status", "introduce_content")
SELECT 'OPUSSPORT', 'en_US', '23', '', '', '', 'normal', ''
WHERE not EXISTS(SELECT id FROM api_i18n where api_id=23 and locale='en_US');

INSERT INTO "api_i18n" ("name", "locale", "api_id", "logo1", "logo2", "cover", "introduce_status", "introduce_content")
SELECT '歐普斯體育', 'zh_TW', '23', '', '', '', 'normal', ''
WHERE not EXISTS(SELECT id FROM api_i18n where api_id=23 and locale='zh_TW');

INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json", "gametype")
SELECT '24', '0', now(), '0', now(), 'f', NULL, NULL, NULL, NULL
WHERE not EXISTS(SELECT id FROM api_order_log where api_id=24 and type='0');

INSERT INTO "api_order_log" ("api_id", "start_id", "update_time", "type", "start_time", "is_need_account", "end_id", "end_time", "ext_json", "gametype")
SELECT '23', '0', now(), '0', now(), 'f', NULL, NULL, NULL, NULL
WHERE not EXISTS(SELECT id FROM api_order_log where api_id=23 and type='0');



