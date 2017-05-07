-- auto gen by admin 2016-04-20 20:58:10
INSERT INTO sys_dict (module,dict_type,dict_code,order_num,remark,active)
SELECT 'notice', 'auto_event_type', 'SCHEDULE_OVERTIME', 24, '任务超时', 't'
WHERE 'SCHEDULE_OVERTIME' not in (SELECT dict_code from sys_dict where module = 'notice' and dict_type = 'auto_event_type');

INSERT INTO sys_dict ( "module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'notice', 'auto_event_type', 'BALANCE_AUTO_FREEZON', NULL, '余额冻结(自动)', NULL, 't'
where 'BALANCE_AUTO_FREEZON' not in(SELECT dict_code FROM sys_dict WHERE module='notice' and dict_type='auto_event_type');

DROP SEQUENCE IF EXISTS order_id_api_trans_seq;

DELETE FROM site_i18n where "module"='setting' AND "type"='game_tag';

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") VALUES ('setting', 'game_tag', 'hot_game', 'zh_CN', '热门游戏', '0', NULL, NULL, 't');
INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") VALUES ('setting', 'game_tag', 'hot_game', 'en_US', 'Hot Game', '0', NULL, NULL, 't');
INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") VALUES ('setting', 'game_tag', 'hot_game', 'zh_TW', '热门游戏', '0', NULL, NULL, 't');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") VALUES ('setting', 'game_tag', 'Slots', 'zh_CN', '老虎机', '0', NULL, NULL, 't');
INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") VALUES ('setting', 'game_tag', 'Slots', 'en_US', '老虎机', '0', NULL, NULL, 't');
INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") VALUES ('setting', 'game_tag', 'Slots', 'zh_TW', '老虎机', '0', NULL, NULL, 't');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") VALUES ('setting', 'game_tag', 'Video poker', 'zh_CN', '奖金老虎机', '0', NULL, NULL, 't');
INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") VALUES ('setting', 'game_tag', 'Video poker', 'en_US', '奖金老虎机', '0', NULL, NULL, 't');
INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") VALUES ('setting', 'game_tag', 'Video poker', 'zh_TW', '奖金老虎机', '0', NULL, NULL, 't');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") VALUES ('setting', 'game_tag', 'Jackpots', 'zh_CN', '累积奖池', '0', NULL, NULL, 't');
INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") VALUES ('setting', 'game_tag', 'Jackpots', 'en_US', '累积奖池', '0', NULL, NULL, 't');
INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") VALUES ('setting', 'game_tag', 'Jackpots', 'zh_TW', '累积奖池', '0', NULL, NULL, 't');


INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") VALUES ('setting', 'game_tag', 'Table games', 'zh_CN', '桌面游戏', '0', NULL, NULL, 't');
INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") VALUES ('setting', 'game_tag', 'Table games', 'en_US', '桌面游戏', '0', NULL, NULL, 't');
INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") VALUES ('setting', 'game_tag', 'Table games', 'zh_TW', '桌面游戏', '0', NULL, NULL, 't');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") VALUES ('setting', 'game_tag', 'Scratch Card', 'zh_CN', '刮刮卡', '0', NULL, NULL, 't');
INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") VALUES ('setting', 'game_tag', 'Scratch Card', 'en_US', '刮刮卡', '0', NULL, NULL, 't');
INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") VALUES ('setting', 'game_tag', 'Scratch Card', 'zh_TW', '刮刮卡', '0', NULL, NULL, 't');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") VALUES ('setting', 'game_tag', 'Other', 'zh_CN', '其他游戏', '0', NULL, NULL, 't');
INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") VALUES ('setting', 'game_tag', 'Other', 'en_US', '其他游戏', '0', NULL, NULL, 't');
INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in") VALUES ('setting', 'game_tag', 'Other', 'zh_TW', '其他游戏', '0', NULL, NULL, 't');

 select redo_sqls($$
      ALTER TABLE sport_recommended_site ADD CONSTRAINT u_sport_rec_site UNIQUE (site_id, sport_recommended_id);
  $$);
