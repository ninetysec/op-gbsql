-- auto gen by water 2018-05-14 20:58:25

INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, privilege, built_in, status)
  SELECT 919, 'API-网络状态提醒', 'gameApi/network/notice.html', 'API-网络状态提醒(virtual url)', 9, '', 19, 'boss', 'api:network_notice', 2, '', false, true, true
  where not exists(select id from sys_resource t where t.id = 919);

INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, privilege, built_in, status)
  SELECT 1009, '支付-网络状态提醒', 'payApi/network/notice.html', '支付-网络状态提醒(virtual url)', 10, '', 20, 'boss', 'payApi:network_notice', 2, '', false, true, true
  where not exists(select id from sys_resource t where t.id = 1009);