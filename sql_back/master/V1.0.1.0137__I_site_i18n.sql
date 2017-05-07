-- auto gen by cheery 2015-10-23 13:54:00
--增加活动分类-默认分类
INSERT INTO site_i18n("module", "type", "key", "locale", "value", "remark", "default_value", "built_in")
  SELECT 'operation', 'operate_activity_classify', 'default', 'zh_TW', '默認分類', NULL, NULL, 't'
  WHERE 'default' not in (SELECT key from site_i18n where module = 'operation' and type = 'operate_activity_classify' AND locale = 'zh_TW');

INSERT INTO site_i18n("module", "type", "key", "locale", "value", "remark", "default_value", "built_in")
  SELECT 'operation', 'operate_activity_classify', 'default', 'en_US', 'Default Category', NULL, NULL, 't'
  WHERE 'default' not in (SELECT key from site_i18n where module = 'operation' and type = 'operate_activity_classify' AND locale = 'en_US');

INSERT INTO site_i18n("module", "type", "key", "locale", "value", "remark", "default_value", "built_in")
  SELECT 'operation', 'operate_activity_classify', 'default', 'zh_CN', '默认分类', NULL, NULL, 't'
  WHERE 'default' not in (SELECT key from site_i18n where module = 'operation' and type = 'operate_activity_classify' AND locale = 'zh_CN');

