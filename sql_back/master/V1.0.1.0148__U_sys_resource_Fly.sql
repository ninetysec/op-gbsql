-- auto gen by fly 2015-10-28 17:15:52
UPDATE sys_resource SET url = 'agentPlayer/list.html', remark = '代理中心-玩家管理'
 WHERE "id" = (SELECT "id" FROM sys_resource WHERE "name" = '玩家查询' AND subsys_code = 'mcenterAgent');
