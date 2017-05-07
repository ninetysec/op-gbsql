-- auto gen by tom 2015-11-22 14:08:42
--增加站点类型-默认直营
INSERT INTO site_i18n("module", "type", "key", "locale", "value", "remark", "default_value", "built_in","site_id")
  SELECT 'siteClassify', 'company_site_classify', 'default', 'zh_TW', '直營', NULL, NULL, 't',0
  WHERE 'default' not in (SELECT key from site_i18n where module = 'siteClassify' and type = 'company_site_classify' AND locale = 'zh_TW' AND value = '直營');

INSERT INTO site_i18n("module", "type", "key", "locale", "value", "remark", "default_value", "built_in","site_id")
  SELECT 'siteClassify', 'company_site_classify', 'default', 'en_US', 'outlets', NULL, NULL, 't',0
  WHERE 'default' not in (SELECT key from site_i18n where module = 'siteClassify' and type = 'company_site_classify' AND locale = 'en_US' AND value = 'outlets');

INSERT INTO site_i18n("module", "type", "key", "locale", "value", "remark", "default_value", "built_in","site_id")
  SELECT 'siteClassify', 'company_site_classify', 'default', 'zh_CN', '直营', NULL, NULL, 't',0
  WHERE 'default' not in (SELECT key from site_i18n where module = 'siteClassify' and type = 'company_site_classify' AND locale = 'zh_CN' AND value = '直营');


  --增加活动分类-默认销售
INSERT INTO site_i18n("module", "type", "key", "locale", "value", "remark", "default_value", "built_in","site_id")
  SELECT 'siteClassify', 'company_site_classify', 'default', 'zh_TW', '銷售', NULL, NULL, 't',0
  WHERE 'default' not in (SELECT key from site_i18n where module = 'siteClassify' and type = 'company_site_classify' AND locale = 'zh_TW' AND value = '銷售');

INSERT INTO site_i18n("module", "type", "key", "locale", "value", "remark", "default_value", "built_in","site_id")
  SELECT 'siteClassify', 'company_site_classify', 'default', 'en_US', 'sale', NULL, NULL, 't',0
  WHERE 'default' not in (SELECT key from site_i18n where module = 'siteClassify' and type = 'company_site_classify' AND locale = 'en_US' AND value = 'sale');

INSERT INTO site_i18n("module", "type", "key", "locale", "value", "remark", "default_value", "built_in","site_id")
  SELECT 'siteClassify', 'company_site_classify', 'default', 'zh_CN', '销售', NULL, NULL, 't',0
  WHERE 'default' not in (SELECT key from site_i18n where module = 'siteClassify' and type = 'company_site_classify' AND locale = 'zh_CN' AND value = '销售');