-- auto gen by Longer 2015-09-06

--自动账号冻结消息模板
insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','account_frozen','comet','2b801fbd304e4b518393bdb9bf1d6c24',true,'zh_CN','','', true,'账号冻结','密码错误超过${times}次!',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e4b518393bdb9bf1d6c24' and locale='zh_CN' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','account_frozen','comet','2b801fbd304e4b518393bdb9bf1d6c24',true,'zh_TW','','', true,'賬號凍結','密碼錯誤超過${times}次!',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e4b518393bdb9bf1d6c24' and locale='zh_TW' );

insert into notice_tmpl( tmpl_type, event_type, publish_method, group_code, active, locale, title, content, default_active, default_title, default_content, create_time, create_user, update_time, update_user, built_in)
  select 'auto','account_frozen','comet','2b801fbd304e4b518393bdb9bf1d6c24',true,'en_US','','', true,'Account Freezon','Passowrd error more than ${times} times!',now(),1,now(),1,true
  where not exists (select id from notice_tmpl where group_code='2b801fbd304e4b518393bdb9bf1d6c24' and locale='en_US' );

