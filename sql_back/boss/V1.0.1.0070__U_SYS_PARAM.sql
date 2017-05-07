-- auto gen by tom 2016-01-26 14:44:30
delete from  sys_param where MODULE='boss_site' and param_type='domian_param';

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
 SELECT 'master', 'domain_param', 'site_domain', 'mcenter', 'mcenter', 1, '站点-参数', NULL, 'true', '0'
   WHERE 'domain_param' not in (SELECT param_type from sys_param where module = 'master' and param_type = 'domain_param');