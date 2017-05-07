-- auto gen by tom 2016-01-12 17:06:46
update sys_dict set dict_code = 'PLAYER_ACCOUNT_FREEZON',remark='玩家账号冻结' where dict_type='manual_event_type' and dict_code='ACCOUNT_FREEZON';
update sys_dict set dict_code = 'PLAYER_ACCOUNT_STOP',remark='玩家账号停用' where dict_type='manual_event_type' and dict_code='ACCOUNT_STOP';
update sys_dict set dict_code = 'PLAYER_WITHDRAWAL_AUDIT_FAIL',remark='玩家取款审核失败' where dict_type='manual_event_type' and dict_code='WITHDRAWAL_AUDIT_FAIL';
update sys_dict set dict_code = 'REFUSE_PLAYER_WITHDRAWAL',remark='拒绝玩家取款' where dict_type='manual_event_type' and dict_code='REFUSE_WITHDRAWAL';

insert into sys_dict(module,dict_type,dict_code,order_num,remark,parent_code,active)
  select 'notice','manual_event_type','ACENTER_ACCOUNT_FREEZON',null,'代理账号冻结','','true'
  where 'ACENTER_ACCOUNT_FREEZON' not in (select dict_code from sys_dict where module='notice' and dict_type='manual_event_type');

insert into sys_dict(module,dict_type,dict_code,order_num,remark,parent_code,active)
  select 'notice','manual_event_type','TCENTER_ACCOUNT_FREEZON',null,'总代账号冻结','','true'
  where 'TCENTER_ACCOUNT_FREEZON' not in (select dict_code from sys_dict where module='notice' and dict_type='manual_event_type');

insert into sys_dict(module,dict_type,dict_code,order_num,remark,parent_code,active)
  select 'notice','manual_event_type','ACENTER_ACCOUNT_STOP',null,'代理账号停用','','true'
  where 'ACENTER_ACCOUNT_STOP' not in (select dict_code from sys_dict where module='notice' and dict_type='manual_event_type');

insert into sys_dict(module,dict_type,dict_code,order_num,remark,parent_code,active)
  select 'notice','manual_event_type','TCENTER_ACCOUNT_STOP',null,'总代账号停用','','true'
  where 'TCENTER_ACCOUNT_STOP' not in (select dict_code from sys_dict where module='notice' and dict_type='manual_event_type');

insert into sys_dict(module,dict_type,dict_code,order_num,remark,parent_code,active)
  select 'notice','manual_event_type','AGENT_WITHDRAWAL_AUDIT_FAIL',null,'代理取款审核失败','','true'
  where 'AGENT_WITHDRAWAL_AUDIT_FAIL' not in (select dict_code from sys_dict where module='notice' and dict_type='manual_event_type');

insert into sys_dict(module,dict_type,dict_code,order_num,remark,parent_code,active)
  select 'notice','manual_event_type','REFUSE_AGENT_WITHDRAWAL',null,'拒绝代理取款','','true'
  where 'REFUSE_AGENT_WITHDRAWAL' not in (select dict_code from sys_dict where module='notice' and dict_type='manual_event_type');

insert into sys_dict(module,dict_type,dict_code,order_num,remark,parent_code,active)
  select 'notice','manual_event_type','MANUAL_WITHDRAWAL',null,'手动取款','','true'
  where 'MANUAL_WITHDRAWAL' not in (select dict_code from sys_dict where module='notice' and dict_type='manual_event_type');