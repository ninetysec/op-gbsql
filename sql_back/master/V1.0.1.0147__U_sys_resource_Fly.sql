-- auto gen by fly 2015-10-28 17:15:33
UPDATE sys_resource SET url = 'agent/agentIndex.html', remark = '代理中心首页'
 WHERE "id" = (SELECT "id" FROM sys_resource WHERE "name" = '代理首页' AND subsys_code = 'mcenterAgent');
