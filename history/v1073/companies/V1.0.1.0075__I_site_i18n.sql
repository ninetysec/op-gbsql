-- auto gen by admin 2016-04-13 21:21:17
delete from site_i18n where type='game_tag' and module='setting';

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'hot_game', 'zh_CN', '热门游戏', '0', NULL, NULL, 't'

WHERE 'hot_game' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_CN');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'hot_game', 'en_US', 'Hot Game', '0', NULL, NULL, 't'

WHERE 'hot_game' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='en_US');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'hot_game', 'zh_TW', '热门游戏', '0', NULL, NULL, 't'

WHERE 'hot_game' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_TW');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'new_game', 'zh_TW', '最新游戏', '0', NULL, NULL, 't'

WHERE 'new_game' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_TW');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'new_game', 'en_US', 'New Game', '0', NULL, NULL, 't'

WHERE 'new_game' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='en_US');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'new_game', 'zh_CN', '最新游戏', '0', NULL, NULL, 't'

WHERE 'new_game' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_CN');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'Jackpots', 'zh_CN', '累积奖池', '0', NULL, NULL, 't'

WHERE 'Jackpots' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_CN');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'Jackpots', 'en_US', '累积奖池', '0', NULL, NULL, 't'

WHERE 'Jackpots' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='en_US');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'Jackpots', 'zh_TW', '累积奖池', '0', NULL, NULL, 't'

WHERE 'Jackpots' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_TW');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'Video poker', 'zh_CN', '奖金老虎机', '0', NULL, NULL, 't'

WHERE 'Video poker' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_CN');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'Video poker', 'en_US', '奖金老虎机', '0', NULL, NULL, 't'

WHERE 'Video poker' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='en_US');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'Video poker', 'zh_TW', '奖金老虎机', '0', NULL, NULL, 't'

WHERE 'Video poker' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_TW');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'Slots', 'zh_CN', '老虎机', '0', NULL, NULL, 't'

WHERE 'Slots' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_CN');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'Slots', 'en_US', '老虎机', '0', NULL, NULL, 't'

WHERE 'Slots' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='en_US');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'Slots', 'zh_TW', '老虎机', '0', NULL, NULL, 't'

WHERE 'Slots' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_TW');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'Table games', 'zh_CN', '桌面游戏', '0', NULL, NULL, 't'

WHERE 'Table games' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_CN');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'Table games', 'en_US', '桌面游戏', '0', NULL, NULL, 't'

WHERE 'Table games' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='en_US');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'Table games', 'zh_TW', '桌面游戏', '0', NULL, NULL, 't'

WHERE 'Table games' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_TW');



INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'Scratch Card', 'zh_CN', '刮刮卡', '0', NULL, NULL, 't'

WHERE 'Scratch Card' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_CN');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'Scratch Card', 'en_US', '刮刮卡', '0', NULL, NULL, 't'

WHERE 'Scratch Card' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='en_US');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'Scratch Card', 'zh_TW', '刮刮卡', '0', NULL, NULL, 't'

WHERE 'Scratch Card' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_TW');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'Other', 'zh_CN', '其他游戏', '0', NULL, NULL, 't'

WHERE 'Other' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_CN');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'Other', 'en_US', '其他游戏', '0', NULL, NULL, 't'

WHERE 'Other' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='en_US');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") SELECT 'setting', 'game_tag', 'Other', 'zh_TW', '其他游戏', '0', NULL, NULL, 't'

WHERE 'Other' not in(SELECT key FROM site_i18n WHERE module='setting' and type='game_tag' and locale='zh_TW');