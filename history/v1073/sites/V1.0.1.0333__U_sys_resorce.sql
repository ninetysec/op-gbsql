-- auto gen by cherry 2016-11-26 19:57:12
DELETE FROM sys_resource WHERE parent_id = 302 AND resource_type = '2';

INSERT INTO sys_resource ("id", "name", url, remark, parent_id, "structure", sort_num, subsys_code, permission, resource_type, icon, built_in, privilege, status)
SELECT 30201, '查看', 'fund/deposit/online/list.html', '线上支付记录-查看（辅）', 302, '', NULL, 'mcenter', 'fund:onlinedeposit', '2', '', 't', 'f', 't'
WHERE 'fund/deposit/online/list.html' NOT IN (SELECT url FROM sys_resource WHERE parent_id = 302 AND resource_type = '2');

INSERT INTO sys_resource ("id", "name", url, remark, parent_id, "structure", sort_num, subsys_code, permission, resource_type, icon, built_in, privilege, status)
SELECT 30202, '审核', 'fund/deposit/check/confirmCheck.html', '线上支付记录-审核', 302, '', NULL, 'mcenter', 'fund:onlinedeposit_check', '2', '', 't', 'f', 't'
WHERE 'fund/deposit/check/confirmCheck.html' NOT IN (SELECT url FROM sys_resource WHERE parent_id = 302 AND resource_type = '2');