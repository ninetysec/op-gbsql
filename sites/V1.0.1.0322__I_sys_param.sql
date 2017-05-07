-- auto gen by fei 2016-11-19 13:51:01

INSERT INTO sys_param ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
select 'content', 'pay_account_hide', 'online_banking', 'false', 'false', '1', '公司入款-网银存款-账号隐藏', '', 't', '1'
where 'online_banking' not in(select param_code from sys_param where "module"='content' and param_type='pay_account_hide');

INSERT INTO sys_param ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
select 'content', 'pay_account_hide', 'e_payment', 'false', 'false', '2', '公司入款-电子支付-账号隐藏', '', 't', '1'
where 'e_payment' not in(select param_code from sys_param where "module"='content' and param_type='pay_account_hide');

INSERT INTO sys_param ("module", "param_type", "param_code", "param_value", "default_value", "order_num", "remark", "parent_code", "active", "site_id")
select 'content', 'pay_account_hide', 'atm_counter', 'false', 'false', '3', '公司入款-柜员机/柜台存款-账号隐藏', '', 't', '1'
where 'atm_counter' not in(select param_code from sys_param where "module"='content' and param_type='pay_account_hide');
