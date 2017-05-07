-- auto gen by tom 2016-01-12 11:23:21
update notice_tmpl set event_type='PLAYER_ACCOUNT_FREEZON' where event_type='ACCOUNT_FREEZON' and tmpl_type='manual';
update notice_tmpl set event_type='PLAYER_ACCOUNT_STOP' where event_type='ACCOUNT_STOP' and tmpl_type='manual';
update notice_tmpl set event_type='PLAYER_WITHDRAWAL_AUDIT_FAIL' where event_type='WITHDRAWAL_AUDIT_FAIL' and tmpl_type='manual';
update notice_tmpl set event_type='REFUSE_PLAYER_WITHDRAWAL' where event_type='REFUSE_WITHDRAWAL' and tmpl_type='manual';


insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'manual','ACENTER_ACCOUNT_FREEZON','sms','2b801fbd304e11111393bdb9bf1d6c24',true,'zh_CN','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e11111393bdb9bf1d6c24' and locale='zh_CN' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'manual','ACENTER_ACCOUNT_FREEZON','sms','2b801fbd304e11111393bdb9bf1d6c24',true,'zh_TW','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e11111393bdb9bf1d6c24' and locale='zh_TW' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'manual','ACENTER_ACCOUNT_FREEZON','sms','2b801fbd304e11111393bdb9bf1d6c24',true,'en_US','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e11111393bdb9bf1d6c24' and locale='en_US' );


insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'manual','TCENTER_ACCOUNT_FREEZON','sms','2b801fbd304e11112393bdb9bf1d6c24',true,'zh_CN','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e11112393bdb9bf1d6c24' and locale='zh_CN' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'manual','TCENTER_ACCOUNT_FREEZON','sms','2b801fbd304e11112393bdb9bf1d6c24',true,'zh_TW','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e11112393bdb9bf1d6c24' and locale='zh_TW' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'manual','TCENTER_ACCOUNT_FREEZON','sms','2b801fbd304e11112393bdb9bf1d6c24',true,'en_US','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e11112393bdb9bf1d6c24' and locale='en_US' );



insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'manual','ACENTER_ACCOUNT_STOP','sms','2b801fbd304e11113393bdb9bf1d6c24',true,'zh_CN','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e11113393bdb9bf1d6c24' and locale='zh_CN' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'manual','ACENTER_ACCOUNT_STOP','sms','2b801fbd304e11113393bdb9bf1d6c24',true,'zh_TW','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e11113393bdb9bf1d6c24' and locale='zh_TW' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'manual','ACENTER_ACCOUNT_STOP','sms','2b801fbd304e11113393bdb9bf1d6c24',true,'en_US','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e11113393bdb9bf1d6c24' and locale='en_US' );



insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'manual','TCENTER_ACCOUNT_STOP','sms','2b801fbd304e11114393bdb9bf1d6c24',true,'zh_CN','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e11114393bdb9bf1d6c24' and locale='zh_CN' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'manual','TCENTER_ACCOUNT_STOP','sms','2b801fbd304e11114393bdb9bf1d6c24',true,'zh_TW','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e11114393bdb9bf1d6c24' and locale='zh_TW' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'manual','TCENTER_ACCOUNT_STOP','sms','2b801fbd304e11114393bdb9bf1d6c24',true,'en_US','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e11114393bdb9bf1d6c24' and locale='en_US' );



insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'manual','AGENT_WITHDRAWAL_AUDIT_FAIL','sms','2b801fbd304e11115393bdb9bf1d6c24',true,'zh_CN','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e11115393bdb9bf1d6c24' and locale='zh_CN' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'manual','AGENT_WITHDRAWAL_AUDIT_FAIL','sms','2b801fbd304e11115393bdb9bf1d6c24',true,'zh_TW','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e11115393bdb9bf1d6c24' and locale='zh_TW' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'manual','AGENT_WITHDRAWAL_AUDIT_FAIL','sms','2b801fbd304e11115393bdb9bf1d6c24',true,'en_US','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e11115393bdb9bf1d6c24' and locale='en_US' );



insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'manual','REFUSE_AGENT_WITHDRAWAL','sms','2b801fbd304e11116393bdb9bf1d6c24',true,'zh_CN','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e11116393bdb9bf1d6c24' and locale='zh_CN' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'manual','REFUSE_AGENT_WITHDRAWAL','sms','2b801fbd304e11116393bdb9bf1d6c24',true,'zh_TW','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e11116393bdb9bf1d6c24' and locale='zh_TW' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'manual','REFUSE_AGENT_WITHDRAWAL','sms','2b801fbd304e11116393bdb9bf1d6c24',true,'en_US','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e11116393bdb9bf1d6c24' and locale='en_US' );


insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'manual','MANUAL_WITHDRAWAL','sms','2b801fbd304e11117393bdb9bf1d6c24',true,'zh_CN','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e11117393bdb9bf1d6c24' and locale='zh_CN' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'manual','MANUAL_WITHDRAWAL','sms','2b801fbd304e11117393bdb9bf1d6c24',true,'zh_TW','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e11117393bdb9bf1d6c24' and locale='zh_TW' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'manual','MANUAL_WITHDRAWAL','sms','2b801fbd304e11117393bdb9bf1d6c24',true,'en_US','','', true,'','',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e11117393bdb9bf1d6c24' and locale='en_US' );