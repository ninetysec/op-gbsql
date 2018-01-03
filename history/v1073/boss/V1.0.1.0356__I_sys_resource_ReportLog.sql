-- auto gen by Water 2017-06-26 19:39:59

INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, privilege, built_in, status)
  select 517, '站点报表日志', 'vSiteTaskInformation/list.html', '站点报表日志', 5, null, 17, 'boss', 'maintenance:reportLog', 1, null, false, true, true
  WHERE not exists(select id from sys_resource where id = 517);
