-- auto gen by eagle 2016-02-25 20:10:04
-- siteI18n增加注册开关关闭时的默认提示信息
INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'system_settings', 'proxy', 'zh_TW', '代理注册功能当前已关闭', '0', NULL, NULL, TRUE
WHERE 'proxy' NOT  in(SELECT key FROM site_i18n WHERE module='setting'  AND type='system_settings' AND locale='zh_TW');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'system_settings', 'proxy', 'en_US', '代理注册功能当前已关闭', '0', NULL, NULL, TRUE
WHERE 'proxy' NOT  in(SELECT key FROM site_i18n WHERE module='setting'  AND type='system_settings' AND locale='en_US');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'system_settings', 'proxy', 'zh_CN', '代理注册功能当前已关闭', '0', NULL, NULL, TRUE
WHERE 'proxy' NOT  in(SELECT key FROM site_i18n WHERE module='setting'  AND type='system_settings' AND locale='zh_CN');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'system_settings', 'player', 'zh_TW', '注册功能当前已关闭', '0', NULL, NULL, TRUE
WHERE 'player' NOT  in(SELECT key FROM site_i18n WHERE module='setting'  AND type='system_settings' AND locale='zh_TW');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'system_settings', 'player', 'en_US', '注册功能当前已关闭', '0', NULL, NULL, TRUE
WHERE 'player' NOT  in(SELECT key FROM site_i18n WHERE module='setting'  AND type='system_settings' AND locale='en_US');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'system_settings', 'player', 'zh_CN', '注册功能当前已关闭', '0', NULL, NULL, TRUE
WHERE 'player' NOT  in(SELECT key FROM site_i18n WHERE module='setting'  AND type='system_settings' AND locale='zh_CN');



