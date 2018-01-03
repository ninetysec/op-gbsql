-- auto gen by longer 2015-09-11 10:39:28

-- log	op_type

UPDATE sys_dict SET order_num = 1 WHERE id = 102;
UPDATE sys_dict SET order_num = 2 WHERE id = 103;
UPDATE sys_dict SET order_num = 3 WHERE id = 104;
UPDATE sys_dict SET order_num = 4 WHERE id = 108;
UPDATE sys_dict SET order_num = 5 WHERE id = 105;
UPDATE sys_dict SET order_num = 6 WHERE id = 106;
UPDATE sys_dict SET order_num = 7 WHERE id = 107;
UPDATE sys_dict SET order_num = 99 WHERE id = 101;


insert into sys_dict( module, dict_type, dict_code, order_num, remark, parent_code, active)
    SELECT module, dict_type, 'recharge', 8, remark, parent_code, active from sys_dict where id = 101
    and not exists(select id from sys_dict t where t.module = 'log' and t.dict_type = 'op_type' and t.dict_code = 'recharge');

insert into sys_dict( module, dict_type, dict_code, order_num, remark, parent_code, active)
    SELECT module, dict_type, 'withdraw', 9, remark, parent_code, active from sys_dict where id = 101
    and not exists(select id from sys_dict t where t.module = 'log' and t.dict_type = 'op_type' and t.dict_code = 'withdraw');
