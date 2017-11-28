-- auto gen by cherry 2016-03-30 21:00:42
INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'game_tag', 'All games', 'zh_CN', '所有游戏', '0', NULL, NULL, 't'
WHERE 'All games' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'game_tag', 'All games', 'en_US', '所有游戏', '0', NULL, NULL, 't'
WHERE 'All games' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='en_US');

INSERT INTO "site_i18n"  ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'game_tag', 'All games', 'zh_TW', '所有游戏', '0', NULL, NULL, 't'
WHERE 'All games' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_TW');


INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'game_tag', 'Jackpots', 'zh_CN', '累计大奖', '0', NULL, NULL, 't'
WHERE 'Jackpots' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'game_tag', 'Jackpots', 'en_US', '累计大奖', '0', NULL, NULL, 't'
WHERE 'Jackpots' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'game_tag', 'Jackpots', 'zh_TW', '累计大奖', '0', NULL, NULL, 't'
WHERE 'Jackpots' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'game_tag', 'Slots', 'zh_CN', '老虎机', '0', NULL, NULL, 't'
WHERE 'Slots' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_CN');

INSERT INTO "site_i18n"  ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'game_tag', 'Slots', 'en_US', '老虎机', '0', NULL, NULL, 't'
WHERE 'Slots' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='en_US');

INSERT INTO "site_i18n"  ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'game_tag', 'Slots', 'zh_TW', '老虎机', '0', NULL, NULL, 't'
WHERE 'Slots' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'game_tag', 'Table games', 'zh_CN', '桌面游戏', '0', NULL, NULL, 't'
WHERE 'Table games' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_CN');

INSERT INTO "site_i18n"  ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'game_tag', 'Table games', 'en_US', '桌面游戏', '0', NULL, NULL, 't'
WHERE 'Table games' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='en_US');

INSERT INTO "site_i18n"  ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'game_tag', 'Table games', 'zh_TW', '桌面游戏', '0', NULL, NULL, 't'
WHERE 'Table games' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_TW');

INSERT INTO "site_i18n"  ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'game_tag', 'Video poker', 'zh_CN', '视频扑克', '0', NULL, NULL, 't'
WHERE 'Video poker' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_CN');

INSERT INTO "site_i18n"  ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'game_tag', 'Video poker', 'en_US', '视频扑克', '0', NULL, NULL, 't'
WHERE 'Video poker' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='en_US');

INSERT INTO "site_i18n"  ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'game_tag', 'Video poker', 'zh_TW', '视频扑克', '0', NULL, NULL, 't'
WHERE 'Video poker' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'game_tag', 'Scratch Card', 'zh_CN', '刮刮卡', '0', NULL, NULL, 't'
WHERE 'Scratch Card' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_CN');

INSERT INTO "site_i18n"  ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'game_tag', 'Scratch Card', 'en_US', '刮刮卡', '0', NULL, NULL, 't'
WHERE 'Scratch Card' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='en_US');

INSERT INTO "site_i18n"  ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'game_tag', 'Scratch Card', 'zh_TW', '刮刮卡', '0', NULL, NULL, 't'
WHERE 'Scratch Card' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'game_tag', 'Other', 'zh_CN', '其他游戏', '0', NULL, NULL, 't'
WHERE 'Other' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_CN');

INSERT INTO "site_i18n"  ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'game_tag', 'Other', 'en_US', '其他游戏', '0', NULL, NULL, 't'
WHERE 'Other' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='en_US');

INSERT INTO "site_i18n"  ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'game_tag', 'Other', 'zh_TW', '其他游戏', '0', NULL, NULL, 't'
WHERE 'Other' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_TW');
