-- auto gen by cherry 2016-08-23 20:24:29
update sys_dict set order_num=1,parent_code = null where "module"='player' and dict_type='player_status' and dict_code='1';

update sys_dict set order_num=2,parent_code = null where "module"='player' and dict_type='player_status' and dict_code='3';

update sys_dict set order_num=3,parent_code = null where "module"='player' and dict_type='player_status' and dict_code='4';

update sys_dict set order_num=4,parent_code = null where "module"='player' and dict_type='player_status' and dict_code='2';

UPDATE sys_dict set order_num='8' WHERE "module"='common' and dict_type='fund_type' AND dict_code='atm_counter';

UPDATE sys_dict set order_num='9' WHERE "module"='common' and dict_type='fund_type' AND dict_code='artificial_deposit';

UPDATE sys_dict set order_num='10' WHERE "module"='common' and dict_type='fund_type' AND dict_code='artificial_withdraw';

UPDATE sys_dict set order_num='11' WHERE "module"='common' and dict_type='fund_type' AND dict_code='player_withdraw';

UPDATE sys_dict set order_num='12' WHERE "module"='common' and dict_type='fund_type' AND dict_code='transfer_into';

UPDATE sys_dict set order_num='13' WHERE "module"='common' and dict_type='fund_type' AND dict_code='transfer_out';

UPDATE sys_dict set order_num='14' WHERE "module"='common' and dict_type='fund_type' AND dict_code='backwater';

UPDATE sys_dict set order_num='15' WHERE "module"='common' and dict_type='fund_type' AND dict_code='favourable';

UPDATE sys_dict set order_num='16' WHERE "module"='common' and dict_type='fund_type' AND dict_code='recommend';

UPDATE sys_dict set order_num='17' WHERE "module"='common' and dict_type='fund_type' AND dict_code='refund_fee';

