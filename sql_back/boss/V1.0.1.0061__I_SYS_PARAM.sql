-- auto gen by tom 2016-01-18 17:11:01
INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
 SELECT 'siteClassify', 'company_site_classify', 'zy', 'zy', 'zy', 1, '站点类型-直营', NULL, 'true', '0'
   WHERE 'zy' not in (SELECT param_value from sys_param where module = 'siteClassify' and param_type = 'company_site_classify');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
 SELECT 'siteClassify', 'company_site_classify', 'sale', 'sale', 'sale', 2, '站点类型-销售', NULL, 'true', '0'
   WHERE 'sale' not in (SELECT param_value from sys_param where module = 'siteClassify' and param_type = 'company_site_classify');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
 SELECT 'boss_site', 'domian_param', 'site_domain', 'master', 'master', 1, '总控-站点-参数', NULL, 'true', '0'
   WHERE 'domian_param' not in (SELECT param_type from sys_param where module = 'boss_site' and param_type = 'domian_param');