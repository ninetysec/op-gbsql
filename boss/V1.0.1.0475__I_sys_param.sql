-- auto gen by george 2017-12-21 16:03:58
delete FROM sys_param WHERE module='content' AND param_type='domain_type' and  param_code='detection';
delete FROM sys_param WHERE module='content' AND param_type='domain_type' and  param_code='vip';


INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'content', 'domain_type', 'paycname', '/pay/cname.html', '/pay/cname.html', '2', '支付cname', '', 't', '0'
WHERE NOT EXISTS(SELECT param_code, module,param_type FROM sys_param WHERE param_code = 'paycname' AND module = 'content' AND param_type='domain_type');

INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'content', 'domain_type', 'indexcname', '/index/cname.html', '/index/cname.html', '2', '主页name', '', 't', '0'
WHERE NOT EXISTS(SELECT param_code, module,param_type FROM sys_param WHERE param_code = 'indexcname' AND module = 'content' AND param_type='domain_type');
