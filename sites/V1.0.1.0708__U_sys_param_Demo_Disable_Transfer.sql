-- auto gen by water 2018-03-15 18:04:40

update sys_param set operate = 0
where module = 'setting' and param_type = 'fund' and param_code = 'disable_transfer';

update sys_param set operate = 0,remark = '演示站(默认禁止转帐)'
where module = 'setting' and param_type = 'fund' and param_code = 'demo'