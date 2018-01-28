-- auto gen by george 2018-01-28 09:15:40

INSERT INTO "api_type" ("id", "url", "parameter", "order_num", "__clean__") SELECT '5', '', '', '5', NULL WHERE not EXISTS (SELECT id FROM api_type where id=5);


INSERT INTO "api_type_i18n" ( "api_type_id", "name", "local", "cover") SELECT  '5', '棋牌', 'zh_TW', ''  WHERE not EXISTS (SELECT id FROM api_type_i18n where api_type_id=5 and local='zh_TW');
INSERT INTO "api_type_i18n" ( "api_type_id", "name", "local", "cover") SELECT '5', 'Chess', 'en_US', '' WHERE not EXISTS (SELECT id FROM api_type_i18n where api_type_id=5 and local='en_US');
INSERT INTO "api_type_i18n" ( "api_type_id", "name", "local", "cover") SELECT  '5', '棋牌', 'zh_CN', '' WHERE not EXISTS (SELECT id FROM api_type_i18n where api_type_id=5 and local='zh_CN');
INSERT INTO "api_type_i18n" ( "api_type_id", "name", "local", "cover") SELECT  '5', '棋牌', 'ja_JP', NULL WHERE not EXISTS (SELECT id FROM api_type_i18n where api_type_id=5 and local='ja_JP');