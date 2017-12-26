-- auto gen by george 2017-12-19 20:02:24
INSERT INTO "sys_param" ( "module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
SELECT 'content', 'domain_type', 'creditPay', '/creditPay', '/creditPay', '5', '买分支付域名', '', 't', '0'
WHERE NOT EXISTS(SELECT param_code, module,param_type FROM sys_param WHERE param_code = 'creditPay' AND module = 'content' AND param_type='domain_type');
