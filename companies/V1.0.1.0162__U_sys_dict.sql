-- auto gen by cherry 2016-08-30 20:02:56
update sys_dict set dict_type='auto_event_type' where "module"='notice' and dict_code='MANUAL_WITHDRAWAL' and dict_type='manual_event_type';

DELETE from sys_dict where dict_code='SALE_AUDIT_FAIL' and dict_type='manual_event_type';

DELETE from sys_dict where dict_code='CHANGE_PLAYER_DATA' and dict_type='manual_event_type';

--添加排序

update sys_dict set order_num= 1 where dict_type='manual_event_type' and dict_code='PLAYER_ACCOUNT_FREEZON';

update sys_dict set order_num= 2 where dict_type='manual_event_type' and dict_code='ACENTER_ACCOUNT_FREEZON';

update sys_dict set order_num= 3 where dict_type='manual_event_type' and dict_code='TCENTER_ACCOUNT_FREEZON';

update sys_dict set order_num= 4 where dict_type='manual_event_type' and dict_code='BALANCE_FREEZON';

update sys_dict set order_num= 5 where dict_type='manual_event_type' and dict_code='FORCE_KICK_OUT';

update sys_dict set order_num= 6 where dict_type='manual_event_type' and dict_code='PLAYER_ACCOUNT_STOP';

update sys_dict set order_num= 7 where dict_type='manual_event_type' and dict_code='ACENTER_ACCOUNT_STOP';

update sys_dict set order_num= 8 where dict_type='manual_event_type' and dict_code='TCENTER_ACCOUNT_STOP';

update sys_dict set order_num= 9 where dict_type='manual_event_type' and dict_code='DEPOSIT_AUDIT_FAIL';

update sys_dict set order_num= 10 where dict_type='manual_event_type' and dict_code='PLAYER_WITHDRAWAL_AUDIT_FAIL';

update sys_dict set order_num= 11 where dict_type='manual_event_type' and dict_code='AGENT_WITHDRAWAL_AUDIT_FAIL';

update sys_dict set order_num= 12 where dict_type='manual_event_type' and dict_code='REFUSE_PLAYER_WITHDRAWAL';

update sys_dict set order_num= 13 where dict_type='manual_event_type' and dict_code='REFUSE_AGENT_WITHDRAWAL';

update sys_dict set order_num= 14 where dict_type='manual_event_type' and dict_code='PREFERENCE_AUDIT_FAIL';

update sys_dict set order_num= 15 where dict_type='manual_event_type' and dict_code='REFUSE_RETURN_RABBET';

update sys_dict set order_num= 16 where dict_type='manual_event_type' and dict_code='REFUSE_RETURN_COMMISSION';


update sys_dict set parent_code=null where dict_type='manual_event_type';