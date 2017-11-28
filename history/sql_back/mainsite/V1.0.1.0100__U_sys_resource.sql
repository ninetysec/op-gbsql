-- auto gen by cheery 2015-11-24 01:49:52
UPDATE sys_resource SET url = 'report/log/logList.html', remark = '运营中心-报表-日志管理', sort_num = 6 WHERE id = (SELECT id FROM sys_resource WHERE "name" = '日志管理' AND parent_id = 5 AND subsys_code = 'ccenter');
UPDATE sys_resource SET url = 'report/rebate/rebateIndex.html', remark = '运营中心-报表-返佣统计', sort_num = 5 WHERE id = (SELECT id FROM sys_resource WHERE "name" = '返佣统计' AND parent_id = 5 AND subsys_code = 'ccenter');
UPDATE sys_resource SET url = 'report/backwater/reindex.html', remark = '运营中心-报表-返水统计', sort_num = 4 WHERE id = (SELECT id FROM sys_resource WHERE "name" = '返水统计' AND parent_id = 5 AND subsys_code = 'ccenter');
UPDATE sys_resource SET url = 'report/operating/list.html', remark = '运营中心-报表-经营报表', sort_num = 3 WHERE id = (SELECT id FROM sys_resource WHERE "name" = '经营报表' AND parent_id = 5 AND subsys_code = 'ccenter');


