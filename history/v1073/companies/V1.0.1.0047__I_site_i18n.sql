-- auto gen by cherry 2016-03-08 14:39:26
INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT  'setting', 'site_name', 'name', 'zh_CN', '默认运营商', '-1', '默认运营商', '', 'f'
WHERE 'name' not in(SELECT key FROM site_i18n WHERE module='setting' and type='site_name' AND locale='zh_CN' AND site_id='-1');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT  'setting', 'site_name', 'name', 'zh_TW', '默认运营商', '-1', '默认运营商', NULL, 'f'
WHERE 'name' not in(SELECT key FROM site_i18n WHERE module='setting' and type='site_name' AND locale='zh_TW'AND site_id='-1');

INSERT INTO "site_i18n" ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'site_name', 'name', 'en_US', '默认运营商', '-1', '默认运营商', NULL, 'f'
WHERE 'name' not in(SELECT key FROM site_i18n WHERE module='setting' and type='site_name' AND locale='en_US'AND site_id='-1');
