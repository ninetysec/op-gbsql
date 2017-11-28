-- auto gen by tom 2016-02-25 09:17:29
update sys_dict set dict_code='PLAYER_REGISTER_SUCCESS',remark='玩家注册成功' WHERE DICT_CODE='REGISTRY_SUCCESS';
DELETE FROM SYS_DICT WHERE dict_code='WITHDRAWAL_AUDIT_SUCCESS';
DELETE FROM SYS_DICT WHERE dict_code='DEDUCT_MONEY_FROM_PLAYER';
DELETE FROM SYS_DICT WHERE dict_code='DEPOSIT_FOR_PLAYER';
INSERT INTO SYS_DICT(module,dict_type,dict_code,order_num,remark,parent_code,active)
select 'notice','auto_event_type','AGENT_REGISTER_SUCCESS',7,'代理注册成功',null,true
where 'AGENT_REGISTER_SUCCESS' not in (select dict_code from SYS_DICT where dict_type='auto_event_type');

INSERT INTO SYS_DICT(module,dict_type,dict_code,order_num,remark,parent_code,active)
select 'notice','auto_event_type','PLAYER_WITHDRAWAL_AUDIT_SUCCESS',9,'玩家取款审核成功',null,true
where 'PLAYER_WITHDRAWAL_AUDIT_SUCCESS' not in (select dict_code from SYS_DICT where dict_type='auto_event_type');

INSERT INTO SYS_DICT(module,dict_type,dict_code,order_num,remark,parent_code,active)
select 'notice','auto_event_type','AGENT_WITHDRAWAL_AUDIT_SUCCESS',10,'代理取款审核成功',null,true
where 'AGENT_WITHDRAWAL_AUDIT_SUCCESS' not in (select dict_code from SYS_DICT where dict_type='auto_event_type');

INSERT INTO SYS_DICT(module,dict_type,dict_code,order_num,remark,parent_code,active)
select 'notice','auto_event_type','MANUAL_DEPOSIT_SUCCESS',11,'手动存款成功',null,true
where 'MANUAL_DEPOSIT_SUCCESS' not in (select dict_code from SYS_DICT where dict_type='auto_event_type');

INSERT INTO SYS_DICT(module,dict_type,dict_code,order_num,remark,parent_code,active)
select 'notice','auto_event_type','PREFERENTIAL_APPLY_SUCCESS',12,'优惠申请成功',null,true
where 'PREFERENTIAL_APPLY_SUCCESS' not in (select dict_code from SYS_DICT where dict_type='auto_event_type');

INSERT INTO SYS_DICT(module,dict_type,dict_code,order_num,remark,parent_code,active)
select 'notice','auto_event_type','PREFERENCE_AUDIT_SUCCESS',12,'优惠审核成功',null,true
where 'PREFERENCE_AUDIT_SUCCESS' not in (select dict_code from SYS_DICT where dict_type='auto_event_type');

INSERT INTO SYS_DICT(module,dict_type,dict_code,order_num,remark,parent_code,active)
select 'notice','auto_event_type','PLAYER_REBATE_SUCCESS',13,'玩家返水成功',null,true
where 'PLAYER_REBATE_SUCCESS' not in (select dict_code from SYS_DICT where dict_type='auto_event_type');

INSERT INTO SYS_DICT(module,dict_type,dict_code,order_num,remark,parent_code,active)
select 'notice','auto_event_type','AGENT_RAKEBACK_SUCCESS',14,'代理返佣成功',null,true
where 'AGENT_RAKEBACK_SUCCESS' not in (select dict_code from SYS_DICT where dict_type='auto_event_type');

INSERT INTO SYS_DICT(module,dict_type,dict_code,order_num,remark,parent_code,active)
select 'notice','auto_event_type','MANUAL_MODIFY_PLAYER',15,'手动修改玩家资料',null,true
where 'MANUAL_MODIFY_PLAYER' not in (select dict_code from SYS_DICT where dict_type='auto_event_type');

INSERT INTO SYS_DICT(module,dict_type,dict_code,order_num,remark,parent_code,active)
select 'notice','auto_event_type','LOGO_AUDIT_FAIL',15,'LOGO审核失败',null,true
where 'LOGO_AUDIT_FAIL' not in (select dict_code from SYS_DICT where dict_type='auto_event_type');
DELETE FROM SYS_DICT WHERE MODULE ='notice' AND DICT_CODE ='TEST';