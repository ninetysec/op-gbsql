-- auto gen by fly 2015-11-04 14:47:32
-- 应 bug-1395要求将 '佣金报表' 改为 '返佣统计'
UPDATE sys_resource SET "name" = '返佣统计' WHERE "id" = (SELECT "id" FROM sys_resource WHERE url = 'report/settlementRebate/report.html' AND subsys_code = 'mcenter');
