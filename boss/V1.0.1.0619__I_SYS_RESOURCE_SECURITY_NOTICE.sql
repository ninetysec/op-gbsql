-- auto gen by water 2018-09-20 17:31:23

-- 安全-网络状态提醒 menu
INSERT INTO sys_resource (id, name, url, remark, parent_id, structure, sort_num, subsys_code, permission, resource_type, icon, privilege, built_in, status)
select 508, '安全-网络状态提醒', 'security/network/notice.html', '安全-网络状态提醒(virtual url)', 5, '', 8, 'boss', 'security:network_notice', 2, '', false, true, true
where not exists(select id from sys_resource t where t.id = 508);