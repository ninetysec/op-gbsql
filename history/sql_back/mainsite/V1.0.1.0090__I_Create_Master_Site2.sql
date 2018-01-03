-- auto gen by longer 2015-11-20 10:53:12
-- auto gen by longer 2015-11-17 10:26:34


--开站需要处理的数据库




SELECT redo_sqls($$
  alter TABLE site_i18n add COLUMN built_in BOOL;
$$);
COMMENT ON COLUMN site_i18n.built_in IS '是否内置';



--站长用户
INSERT INTO sys_user ( username, password,status,default_locale, default_timezone, subsys_code, user_type, site_id, owner_id)
  select 'master2', '443be37bd324089f6524a8f69e204a5f', '1', 'zh_CN', 'GMT+8', 'mcenter', '2',1, 0 where not exists(select username from sys_user where username = 'master2');

--数据源
  INSERT INTO sys_datasource (id, name, url, username, password, initial_size, max_active, min_idle, max_wait, remark, ip, port, dbname, status)
  select 2, 'master-2', 'jdbc:postgresql://192.168.0.88:5432/gamebox-master2?characterEncoding=UTF-8', 'postgres', 'postgres', 3, 10, 3, 10, '测试站长1数据源,密码应该加密!', '192.168.0.88', 5432, 'gamebox-master2', '1'
  where not exists( select id from sys_datasource where id = 2);

delete from sys_site where id = 2;
INSERT INTO sys_site (id, sys_user_id, name, theme, sso_theme, status, is_buildin, postfix, short_name, main_currency, main_language, web_site, opening_time, timezone, traffic_statistics, code, logo_path,parent_id)
VALUES (2, (select id from sys_user where username = 'master2'), '站长1-站点2', '', 'mcenter', '', true, '@cn', '', 'CNY', 'zh_CN', 'www.zhihu.com', '2015-11-17 15:17:26.000000', 'GMT+8', '', '0002', 'Logo/1/1440489057635.jpg',0);


--域名
SELECT redo_sqls($$
  INSERT INTO sys_domain ( sys_user_id, domain, is_default, is_enable, is_deleted, sort, site_id, subsys_code, create_user, create_time, update_user, update_time, is_for_all_rank, page_url, name, agent_id, resolve_status) VALUES ( (select id from sys_user where username = 'master2'), 'mcenter2.dev.so', false, true, false, null, 2, 'mcenter', null, null, null, null, false, null, null, null, '2');
  INSERT INTO sys_domain ( sys_user_id, domain, is_default, is_enable, is_deleted, sort, site_id, subsys_code, create_user, create_time, update_user, update_time, is_for_all_rank, page_url, name, agent_id, resolve_status) VALUES ( (select id from sys_user where username = 'master2'), 'mcenter2.me.so', false, true, false, null, 2, 'mcenter', null, null, null, null, false, null, null, null, '2');
  INSERT INTO sys_domain ( sys_user_id, domain, is_default, is_enable, is_deleted, sort, site_id, subsys_code, create_user, create_time, update_user, update_time, is_for_all_rank, page_url, name, agent_id, resolve_status) VALUES ( (select id from sys_user where username = 'master2'), 'mcenter2.test.so', false, true, false, null, 2, 'mcenter', null, null, null, null, false, null, null, null, '2');
  INSERT INTO sys_domain ( sys_user_id, domain, is_default, is_enable, is_deleted, sort, site_id, subsys_code, create_user, create_time, update_user, update_time, is_for_all_rank, page_url, name, agent_id, resolve_status) VALUES ( (select id from sys_user where username = 'master2'), 'msites2.dev.so', false, true, false, null, 2, 'mcenter', null, null, null, null, false, null, null, null, '2');
  INSERT INTO sys_domain ( sys_user_id, domain, is_default, is_enable, is_deleted, sort, site_id, subsys_code, create_user, create_time, update_user, update_time, is_for_all_rank, page_url, name, agent_id, resolve_status) VALUES ( (select id from sys_user where username = 'master2'), 'msites2.me.so', false, true, false, null, 2, 'mcenter', null, null, null, null, false, null, null, null, '2');
  INSERT INTO sys_domain ( sys_user_id, domain, is_default, is_enable, is_deleted, sort, site_id, subsys_code, create_user, create_time, update_user, update_time, is_for_all_rank, page_url, name, agent_id, resolve_status) VALUES ( (select id from sys_user where username = 'master2'), 'msites2.test.so', false, true, false, null, 2, 'mcenter', null, null, null, null, false, null, null, null, '2');
  INSERT INTO sys_domain ( sys_user_id, domain, is_default, is_enable, is_deleted, sort, site_id, subsys_code, create_user, create_time, update_user, update_time, is_for_all_rank, page_url, name, agent_id, resolve_status) VALUES ( (select id from sys_user where username = 'master2'), 'pcenter2.dev.so', false, true, false, null, 2, 'pcenter', null, null, null, null, false, null, null, null, '2');
  INSERT INTO sys_domain ( sys_user_id, domain, is_default, is_enable, is_deleted, sort, site_id, subsys_code, create_user, create_time, update_user, update_time, is_for_all_rank, page_url, name, agent_id, resolve_status) VALUES ( (select id from sys_user where username = 'master2'), 'pcenter2.me.so', false, true, false, null, 2, 'pcenter', null, null, null, null, false, null, null, null, '2');
  INSERT INTO sys_domain ( sys_user_id, domain, is_default, is_enable, is_deleted, sort, site_id, subsys_code, create_user, create_time, update_user, update_time, is_for_all_rank, page_url, name, agent_id, resolve_status) VALUES ( (select id from sys_user where username = 'master2'), 'pcenter2.test.so', false, true, false, null, 2, 'pcenter', null, null, null, null, false, null, null, null, '2');
$$);

--动态列
insert into sys_list_operator(class_full_name, op_type, description, content, is_default, site_id, subsys_code)
  select class_full_name, op_type, description, content, is_default, 2, subsys_code from sys_list_operator where not exists(select id from sys_list_operator where site_id = 2 ) ;


insert into site_api (site_id, api_id, status, order_num)
  select 2, api_id, status, order_num from site_api where not exists(select id from site_api where site_id = 2 );

insert into site_api_i18n ( site_id, api_id, name, local, logo1, logo2, cover)
  select 2, api_id, name, local, logo1, logo2, cover from site_api_i18n where not exists(select id from site_api_i18n where site_id = 2 );

insert into site_api_type (site_id, api_type_id, url, parameter, order_num, status)
  select 2, api_type_id, url, parameter, order_num, status from site_api_type where not exists(select id from site_api_type where site_id = 2 );

insert into site_api_type_i18n (site_id, api_type_id, name, local, cover)
  select 2, api_type_id, name, local, cover from site_api_type_i18n where not exists(select id from site_api_type_i18n where site_id = 2 );

insert into site_api_type_relation ( site_id, api_id, api_type_id, order_num)
  select 2, api_id, api_type_id, order_num from site_api_type_relation where not exists(select id from site_api_type_relation where site_id = 2 );

insert into site_confine_area (site_id, time_type, create_time, end_time, create_user, nation, province, city, delta, remark)
  select 2, time_type, create_time, end_time, create_user, nation, province, city, delta, remark from site_confine_area where not exists(select id from site_confine_area where site_id = 2 );



insert into site_confine_ip (site_id, time_type, create_time, end_time, create_user, type, start_ip, end_ip, remark)
  select 2, time_type, create_time, end_time, create_user, type, start_ip, end_ip, remark from site_confine_ip where not exists(select id from site_confine_ip where site_id = 2 );

insert into site_contacts (site_id, name, mail, phone, position_id, sex, create_time, create_user)
  select 2, name, mail, phone, position_id, sex, create_time, create_user from site_contacts where not exists(select id from site_contacts where site_id = 2 );

insert into site_contacts_notice (site_id, contacts_id, notice_project, notice_type, create_time, create_user)
  select 2, contacts_id, notice_project, notice_type, create_time, create_user from site_contacts_notice where not exists(select id from site_contacts_notice where site_id = 2 );

insert into site_contacts_position ( site_id, name, create_user, create_time, built_in)
  select 2, name, create_user, create_time, built_in from site_contacts_position where not exists(select id from site_contacts_position where site_id = 2 );

insert into site_currency (site_id, code, status)
  select 2, code, status from site_currency where not exists(select id from site_currency where site_id = 2 );


insert into site_customer_service ( site_id, code, name, parameter, status, create_time, create_user)
  select 2, code, name, parameter, status, create_time, create_user from site_customer_service where not exists(select id from site_customer_service where site_id = 2 );

insert into site_game ( site_id,game_id, api_id, game_type, views, game_type_parent, order_num, url, status)
  select 2, game_id, api_id, game_type, views, game_type_parent, order_num, url, status from site_game where not exists(select id from site_game where site_id = 2 );

insert into site_game_i18n ( site_id, game_id, name, local, cover, introduce_status, game_introduce)
  select 2, game_id, name, local, cover, introduce_status, game_introduce from site_game_i18n where not exists(select id from site_game_i18n where site_id = 2 );

insert into site_i18n (site_id,module, type, key, locale, value, remark, default_value, built_in)
  select 2, module, type, key, locale, value, remark, default_value, built_in from site_i18n where not exists(select id from site_i18n where site_id = 2 );

insert into site_introducer ( site_id, name, create_user, create_time, update_user, update_time)
  select 2, name, create_user, create_time, update_user, update_time from site_introducer where not exists(select id from site_introducer where site_id = 2 );

insert into site_language ( site_id, language, status, logo, open_time)
  select 2, language, status, logo, open_time from site_language where not exists(select id from site_language where site_id = 2 );

insert into site_operate_area ( site_id, code, status, area_ip, open_time)
  select 2, code, status, area_ip, open_time from site_operate_area where not exists(select id from site_operate_area where site_id = 2 );





