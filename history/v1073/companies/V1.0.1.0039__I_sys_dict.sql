-- auto gen by cherry 2016-03-03 10:05:48
INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'agent', 'agent_status', '4', '4', '待审核', NULL, 't'
WHERE '4' not in(SELECT dict_code FROM sys_dict WHERE module='agent' AND dict_type='agent_status');

INSERT INTO "sys_dict" ("module", "dict_type", "dict_code", "order_num", "remark", "parent_code", "active")
SELECT 'agent', 'agent_status', '5', '5', '审核失败', NULL, 't'
WHERE '5' not in(SELECT dict_code FROM sys_dict WHERE module='agent' AND dict_type='agent_status');

INSERT INTO site_i18n ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT  'setting', 'site_name', 'name', 'zh_CN', '默认运营商', '-1', '平台名称', '', 'f'
WHERE 'name' not in(SELECT key FROM site_i18n WHERE module='setting' AND type='site_name' and locale='zh_CN');

INSERT INTO site_i18n ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT  'setting', 'site_name', 'name', 'en_US', '默认运营商', '-1', '平台名称', NULL, 'f'
WHERE 'name' not in(SELECT key FROM site_i18n WHERE module='setting' AND type='site_name' and locale='en_US');

INSERT INTO site_i18n ( "module", "type", "key", "locale", "value", "site_id", "remark", "default_value", "built_in")
SELECT 'setting', 'site_name', 'name', 'zh_TW', '默认运营商', '-1', '平台名称', NULL, 'f'
WHERE 'name' not in(SELECT key FROM site_i18n WHERE module='setting' AND type='site_name' and locale='zh_TW');

UPDATE sys_param SET default_value = '' WHERE param_type = 'privilage_pass_time' AND param_code = 'setting.privilage.pass.time';