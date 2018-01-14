-- auto gen by george 2018-01-14 17:45:01
INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in", "__clean__")
SELECT 'setting', 'game_tag', 'New game', 'zh_CN', '最新游戏', '0', NULL, NULL, 't', NULL
WHERE not EXISTS(SELECT id FROM site_i18n WHERE key='New game' and locale='zh_CN' and module='setting'and type='game_tag');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in", "__clean__")
SELECT 'setting', 'game_tag', 'New game', 'zh_TW', '最新游戏', '0', NULL, NULL, 't', NULL
WHERE not EXISTS(SELECT id FROM site_i18n WHERE key='New game' and locale='zh_TW' and module='setting'and type='game_tag');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in", "__clean__")
SELECT 'setting', 'game_tag', 'New game', 'en_US', 'New Game', '0', NULL, NULL, 't', NULL
WHERE not EXISTS(SELECT id FROM site_i18n WHERE key='New game' and locale='en_US' and module='setting'and type='game_tag');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in", "__clean__")
SELECT 'setting', 'game_tag', 'New game', 'ja_JP', '最新ゲーム', '0', NULL, NULL, 't', NULL
WHERE not EXISTS(SELECT id FROM site_i18n WHERE key='New game' and locale='ja_JP' and module='setting'and type='game_tag');