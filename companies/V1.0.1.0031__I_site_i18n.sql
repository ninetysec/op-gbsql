-- auto gen by cherry 2016-02-25 15:36:36
DELETE FROM site_i18n WHERE type = 'team_type' AND VALUE LIKE '%球队类型%';

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT  'sport_recommended', 'team_type', '1', 'zh_CN', '英超', '0', '球队类型', NULL, 't'
WHERE  '1' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '1', 'zh_TW', '英超', '0', '球队类型', NULL, 't'
WHERE  '1' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '1', 'en_US', '英超', '0', '球队类型', NULL, 't'
WHERE  '1' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '2', 'zh_CN', '英冠', '0', '球队类型', NULL, 't'
WHERE  '2' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '2', 'zh_TW', '英冠', '0', '球队类型', NULL, 't'
WHERE  '2' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '2', 'en_US', '英冠', '0', '球队类型', NULL, 't'
WHERE  '2' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '3', 'zh_CN', '意甲', '0', '球队类型', NULL, 't'
WHERE  '3' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '3', 'zh_TW', '意甲', '0', '球队类型', NULL, 't'
WHERE  '3' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '3', 'en_US', '意甲', '0', '球队类型', NULL, 't'
WHERE  '3' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '4', 'zh_CN', '意乙', '0', '球队类型', NULL, 't'
WHERE  '4' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '4', 'zh_TW', '意乙', '0', '球队类型', NULL, 't'
WHERE  '4' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '4', 'en_US', '意乙', '0', '球队类型', NULL, 't'
WHERE  '4' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '5', 'zh_CN', '德甲', '0', '球队类型', NULL, 't'
WHERE  '5' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '5', 'zh_TW', '德甲', '0', '球队类型', NULL, 't'
WHERE  '5' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '5', 'en_US', '德甲', '0', '球队类型', NULL, 't'
WHERE  '5' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '6', 'zh_CN', '德乙', '0', '球队类型', NULL, 't'
WHERE  '6' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '6', 'zh_TW', '德乙', '0', '球队类型', NULL, 't'
WHERE  '6' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '6', 'en_US', '德乙', '0', '球队类型', NULL, 't'
WHERE  '6' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '7', 'zh_CN', '西甲', '0', '球队类型', NULL, 't'
WHERE  '7' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '7', 'zh_TW', '西甲', '0', '球队类型', NULL, 't'
WHERE  '7' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '7', 'en_US', '西甲', '0', '球队类型', NULL, 't'
WHERE  '7' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '8', 'zh_CN', '法甲', '0', '球队类型', NULL, 't'
WHERE  '8' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '8', 'zh_TW', '法甲', '0', '球队类型', NULL, 't'
WHERE  '8' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '8', 'en_US', '法甲', '0', '球队类型', NULL, 't'
WHERE  '8' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '9', 'zh_CN', '荷甲', '0', '球队类型', NULL, 't'
WHERE  '9' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '9', 'zh_TW', '荷甲', '0', '球队类型', NULL, 't'
WHERE  '9' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '9', 'en_US', '荷甲', '0', '球队类型', NULL, 't'
WHERE  '9' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '10', 'zh_CN', '瑞典超', '0', '球队类型', NULL, 't'
WHERE  '10' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '10', 'zh_TW', '瑞典超', '0', '球队类型', NULL, 't'
WHERE  '10' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '10', 'en_US', '瑞典超', '0', '球队类型', NULL, 't'
WHERE  '10' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '11', 'zh_CN', '中超', '0', '球队类型', NULL, 't'
WHERE  '11' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '11', 'zh_TW', '中超', '0', '球队类型', NULL, 't'
WHERE  '11' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '11', 'en_US', '中超', '0', '球队类型', NULL, 't'
WHERE  '11' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '12', 'zh_CN', '日职联', '0', '球队类型', NULL, 't'
WHERE  '12' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '12', 'zh_TW', '日职联', '0', '球队类型', NULL, 't'
WHERE  '12' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '12', 'en_US', '日职联', '0', '球队类型', NULL, 't'
WHERE  '12' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
select 'sport_recommended', 'team_type', '13', 'zh_CN', '韩Ｋ联', '0', '球队类型', NULL, 't'
WHERE  '13' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
select 'sport_recommended', 'team_type', '13', 'zh_TW', '韩Ｋ联', '0', '球队类型', NULL, 't'
WHERE  '13' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
select 'sport_recommended', 'team_type', '13', 'en_US', '韩Ｋ联', '0', '球队类型', NULL, 't'
WHERE  '13' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '14', 'zh_CN', '澳甲', '0', '球队类型', NULL, 't'
WHERE  '14' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '14', 'zh_TW', '澳甲', '0', '球队类型', NULL, 't'
WHERE  '14' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '14', 'en_US', '澳甲', '0', '球队类型', NULL, 't'
WHERE  '14' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '15', 'zh_CN', '巴西甲', '0', '球队类型', NULL, 't'
WHERE  '15' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '15', 'zh_TW', '巴西甲', '0', '球队类型', NULL, 't'
WHERE  '15' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '15', 'en_US', '巴西甲', '0', '球队类型', NULL, 't'
WHERE  '15' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '16', 'zh_CN', '美职联', '0', '球队类型', NULL, 't'
WHERE  '16' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '16', 'zh_TW', '美职联', '0', '球队类型', NULL, 't'
WHERE  '16' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '16', 'en_US', '美职联', '0', '球队类型', NULL, 't'
WHERE  '16' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '17', 'zh_CN', '欧冠', '0', '球队类型', NULL, 't'
WHERE  '17' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '17', 'zh_TW', '欧冠', '0', '球队类型', NULL, 't'
WHERE  '17' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '17', 'en_US', '欧冠', '0', '球队类型', NULL, 't'
WHERE  '17' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '18', 'zh_CN', '欧联', '0', '球队类型', NULL, 't'
WHERE  '18' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '18', 'zh_TW', '欧联', '0', '球队类型', NULL, 't'
WHERE  '18' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '18', 'en_US', '欧联', '0', '球队类型', NULL, 't'
WHERE  '18' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '19', 'zh_CN', '亚冠', '0', '球队类型', NULL, 't'
WHERE  '19' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '19', 'zh_TW', '亚冠', '0', '球队类型', NULL, 't'
WHERE  '19' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '19', 'en_US', '亚冠', '0', '球队类型', NULL, 't'
WHERE  '19' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
 SELECT 'sport_recommended', 'team_type', '20', 'zh_CN', '国家队', '0', '球队类型', NULL, 't'
WHERE  '20' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
 SELECT 'sport_recommended', 'team_type', '20', 'zh_TW', '国家队', '0', '球队类型', NULL, 't'
WHERE  '20' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
 SELECT 'sport_recommended', 'team_type', '20', 'en_US', '国家队', '0', '球队类型', NULL, 't'
WHERE  '20' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '21', 'zh_CN', '美国NBA', '0', '球队类型', NULL, 't'
WHERE  '21' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '21', 'zh_TW', '美国NBA', '0', '球队类型', NULL, 't'
WHERE  '21' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '21', 'en_US', '美国NBA', '0', '球队类型', NULL, 't'
WHERE  '21' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '22', 'zh_CN', '美国WNBA', '0', '球队类型', NULL, 't'
WHERE  '22' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '22', 'zh_TW', '美国WNBA', '0', '球队类型', NULL, 't'
WHERE  '22' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '22', 'en_US', '美国WNBA', '0', '球队类型', NULL, 't'
WHERE  '22' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '23', 'zh_CN', '中国CBA', '0', '球队类型', NULL, 't'
WHERE  '23' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_CN');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '23', 'zh_TW', '中国CBA', '0', '球队类型', NULL, 't'
WHERE  '23' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='zh_TW');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'sport_recommended', 'team_type', '23', 'en_US', '中国CBA', '0', '球队类型', NULL, 't'
WHERE  '23' not in(SELECT key FROM site_i18n WHERE "module"='sport_recommended' and type='team_type' AND locale='en_US');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "remark", "parent_code", "active")
SELECT 'notice', 'auto_event_type', 'BIND_EMAIL_VERIFICATION_CODE', '邮箱绑定验证码', NULL, 't'
WHERE 'BIND_EMAIL_VERIFICATION_CODE' not in(SELECT dict_code FROM sys_dict WHERE module='notice' and dict_type='auto_event_type');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "remark", "parent_code", "active")
SELECT 'notice', 'auto_event_type', 'MODIFY_STATION_BILL', '修改结算账单', NULL, 't'
WHERE 'MODIFY_STATION_BILL' not in(SELECT dict_code FROM sys_dict WHERE module='notice' and dict_type='auto_event_type');
