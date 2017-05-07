-- auto gen by cherry 2016-02-02 09:36:15
DELETE FROM site_i18n where "module" ='operation' AND type='operate_activity_classify' AND key='default' AND site_id!=0;

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'operation', 'operate_activity_classify', 'default', 'zh_CN', '默认分类', '0', NULL, NULL, 't'
WHERE  'default' not in(SELECT key FROM site_i18n WHERE module='operation' and type='operate_activity_classify' AND locale='zh_CN');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'operation', 'operate_activity_classify', 'default', 'en_US', 'Default Category', '0', NULL, NULL, 't'
WHERE  'default' not in(SELECT key FROM site_i18n WHERE module='operation' and type='operate_activity_classify' AND locale='en_US');

INSERT INTO "site_i18n" ("module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'operation', 'operate_activity_classify', 'default', 'zh_TW', '默認分類', '0', NULL, NULL, 't'
WHERE  'default' not in(SELECT key FROM site_i18n WHERE module='operation' and type='operate_activity_classify' AND locale='zh_TW');
