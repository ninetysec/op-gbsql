-- auto gen by Water 2017-06-07 17:54:05


--pay api
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, privilege, built_in, status)
  select 210, '支付Jar管理', 'operate/payApiProvider/list.html', '支付Jar管理', 2, null, 10, 'boss', 'serve:payApiProvider', 1, null, false, true, true
  where NOT exists (select id from sys_resource where id = 210);

INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, privilege, built_in, status)
  select 21001, '更新支付Jar版本', 'operate/payApiProvider/updateVersion.html', '更新支付Jar版本', 210, null, 1, 'boss', 'serve:payApiProvider_update', 2, null, false, true, true
  where NOT exists (select id from sys_resource where id = 21001);


--game api
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, privilege, built_in, status)
  select 20901, '更新游戏Jar版本', 'gameApiProvider/updateVersion.html', '更新游戏Jar版本', 209, null, 1, 'boss', 'serve:gameApiProvider_update', 2, null, false, true, true
  where NOT exists (select id from sys_resource where id = 20901);

