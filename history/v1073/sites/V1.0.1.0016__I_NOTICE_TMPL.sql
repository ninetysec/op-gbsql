-- auto gen by tom 2016-02-23 11:28:58
DELETE FROM notice_tmpl WHERE event_type='WITHDRAWAL_AUDIT_SUCCESS';
DELETE FROM notice_tmpl WHERE event_type='DEDUCT_MONEY_FROM_PLAYER';
DELETE FROM notice_tmpl WHERE event_type='DEPOSIT_FOR_PLAYER';

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','PLAYER_REGISTER_SUCCESS','sms','2b801fbd304e33336393bdb9bf1d6c24',true,'zh_CN','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e33336393bdb9bf1d6c24' and locale='zh_CN' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','PLAYER_REGISTER_SUCCESS','sms','2b801fbd304e33336393bdb9bf1d6c24',true,'zh_TW','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e33336393bdb9bf1d6c24' and locale='zh_TW' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','PLAYER_REGISTER_SUCCESS','sms','2b801fbd304e33336393bdb9bf1d6c24',true,'en_US','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e33336393bdb9bf1d6c24' and locale='en_US' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','AGENT_REGISTER_SUCCESS','sms','2b801fbd304e33346393bdb9bf1d6c24',true,'zh_CN','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e33346393bdb9bf1d6c24' and locale='zh_CN' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','AGENT_REGISTER_SUCCESS','sms','2b801fbd304e33346393bdb9bf1d6c24',true,'zh_TW','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e33346393bdb9bf1d6c24' and locale='zh_TW' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','AGENT_REGISTER_SUCCESS','sms','2b801fbd304e33346393bdb9bf1d6c24',true,'en_US','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e33346393bdb9bf1d6c24' and locale='en_US' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','DEPOSIT_AUDIT_SUCCESS','sms','2b801fbd304e33356393bdb9bf1d6c24',true,'zh_CN','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e33356393bdb9bf1d6c24' and locale='zh_CN' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','DEPOSIT_AUDIT_SUCCESS','sms','2b801fbd304e33356393bdb9bf1d6c24',true,'zh_TW','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e33356393bdb9bf1d6c24' and locale='zh_TW' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','DEPOSIT_AUDIT_SUCCESS','sms','2b801fbd304e33356393bdb9bf1d6c24',true,'en_US','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e33356393bdb9bf1d6c24' and locale='en_US' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','PLAYER_WITHDRAWAL_AUDIT_SUCCESS','sms','2b801fbd304e00366393bdb9bf1d6c24',true,'zh_CN','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e00366393bdb9bf1d6c24' and locale='zh_CN' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','PLAYER_WITHDRAWAL_AUDIT_SUCCESS','sms','2b801fbd304e00366393bdb9bf1d6c24',true,'zh_TW','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e00366393bdb9bf1d6c24' and locale='zh_TW' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','PLAYER_WITHDRAWAL_AUDIT_SUCCESS','sms','2b801fbd304e00366393bdb9bf1d6c24',true,'en_US','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e00366393bdb9bf1d6c24' and locale='en_US' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','AGENT_WITHDRAWAL_AUDIT_SUCCESS','sms','2b801fbd304e33367393bdb9bf1d6c24',true,'zh_CN','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e33367393bdb9bf1d6c24' and locale='zh_CN' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','AGENT_WITHDRAWAL_AUDIT_SUCCESS','sms','2b801fbd304e33367393bdb9bf1d6c24',true,'zh_TW','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e33367393bdb9bf1d6c24' and locale='zh_TW' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','AGENT_WITHDRAWAL_AUDIT_SUCCESS','sms','2b801fbd304e33367393bdb9bf1d6c24',true,'en_US','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e33367393bdb9bf1d6c24' and locale='en_US' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','MANUAL_DEPOSIT_SUCCESS','sms','2b801fbd304e33368393bdb9bf1d6c24',true,'zh_CN','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e33368393bdb9bf1d6c24' and locale='zh_CN' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','MANUAL_DEPOSIT_SUCCESS','sms','2b801fbd304e33368393bdb9bf1d6c24',true,'zh_TW','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e33368393bdb9bf1d6c24' and locale='zh_TW' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','MANUAL_DEPOSIT_SUCCESS','sms','2b801fbd304e33368393bdb9bf1d6c24',true,'en_US','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e33368393bdb9bf1d6c24' and locale='en_US' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','PREFERENTIAL_APPLY_SUCCESS','sms','2b801fbd304e33379393bdb9bf1d6c24',true,'zh_CN','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e33379393bdb9bf1d6c24' and locale='zh_CN' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','PREFERENTIAL_APPLY_SUCCESS','sms','2b801fbd304e33379393bdb9bf1d6c24',true,'zh_TW','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e33379393bdb9bf1d6c24' and locale='zh_TW' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','PREFERENTIAL_APPLY_SUCCESS','sms','2b801fbd304e33379393bdb9bf1d6c24',true,'en_US','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e33379393bdb9bf1d6c24' and locale='en_US' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','PREFERENCE_AUDIT_SUCCESS','sms','2b801fbd304e13379393bdb9bf1d6c24',true,'zh_CN','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e13379393bdb9bf1d6c24' and locale='zh_CN' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','PREFERENCE_AUDIT_SUCCESS','sms','2b801fbd304e13379393bdb9bf1d6c24',true,'zh_TW','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e13379393bdb9bf1d6c24' and locale='zh_TW' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','PREFERENCE_AUDIT_SUCCESS','sms','2b801fbd304e13379393bdb9bf1d6c24',true,'en_US','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e13379393bdb9bf1d6c24' and locale='en_US' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','PLAYER_REBATE_SUCCESS','sms','2b801fbd304e23379393bdb9bf1d6c24',true,'zh_CN','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e23379393bdb9bf1d6c24' and locale='zh_CN' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','PLAYER_REBATE_SUCCESS','sms','2b801fbd304e23379393bdb9bf1d6c24',true,'zh_TW','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e23379393bdb9bf1d6c24' and locale='zh_TW' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','PLAYER_REBATE_SUCCESS','sms','2b801fbd304e23379393bdb9bf1d6c24',true,'en_US','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e23379393bdb9bf1d6c24' and locale='en_US' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','AGENT_RAKEBACK_SUCCESS','sms','2b801fbd304e53379393btb9bf1d6c24',true,'zh_CN','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e53379393btb9bf1d6c24' and locale='zh_CN' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','AGENT_RAKEBACK_SUCCESS','sms','2b801fbd304e53379393btb9bf1d6c24',true,'zh_TW','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e53379393btb9bf1d6c24' and locale='zh_TW' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','AGENT_RAKEBACK_SUCCESS','sms','2b801fbd304e53379393btb9bf1d6c24',true,'en_US','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e53379393btb9bf1d6c24' and locale='en_US' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','MANUAL_MODIFY_PLAYER','sms','2b801fbd304e77379393btb9bf1d6c24',true,'zh_CN','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e77379393btb9bf1d6c24' and locale='zh_CN' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','MANUAL_MODIFY_PLAYER','sms','2b801fbd304e77379393btb9bf1d6c24',true,'zh_TW','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e77379393btb9bf1d6c24' and locale='zh_TW' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','MANUAL_MODIFY_PLAYER','sms','2b801fbd304e77379393btb9bf1d6c24',true,'en_US','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e77379393btb9bf1d6c24' and locale='en_US' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','LOGO_AUDIT_FAIL','sms','2b801fbd304e88379393btb9bf1d6c24',true,'zh_CN','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e88379393btb9bf1d6c24' and locale='zh_CN' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','LOGO_AUDIT_FAIL','sms','2b801fbd304e88379393btb9bf1d6c24',true,'zh_TW','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e88379393btb9bf1d6c24' and locale='zh_TW' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','LOGO_AUDIT_FAIL','sms','2b801fbd304e88379393btb9bf1d6c24',true,'en_US','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e88379393btb9bf1d6c24' and locale='en_US' );



