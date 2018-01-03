-- auto gen by tony 2016-10-30 16:54:43
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
select 'content', 'domain_type', 'topagent', '/tcenter/passport/login.html', '/tcenter/passport/login.html', null, 'topagent', null, 't', '0'
where 'topagent' not in(select param_code from sys_param where module='content' and param_type='domain_type' and param_code='topagent');
INSERT INTO "sys_param" ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
select 'content', 'domain_type', 'agent', '/acenter/passport/login.html', '/acenter/passport/login.html', null, 'agent', null, 't', '0'
where 'agent' not in(select param_code from sys_param where module='content' and param_type='domain_type' and param_code='agent');
