-- auto gen by fly 2015-11-02 13:52:06
UPDATE sys_resource SET url = 'topAgent/topAgentIndex.html', remark = '总代管理-总代中心首页' WHERE "id" = (SELECT "id" FROM sys_resource WHERE "name" = '总代理首页' AND subsys_code = 'mcenterTopAgent');
UPDATE sys_resource SET url = 'topAgentPlayer/list.html', remark = '总代管理-代理管理-玩家列表', sort_num = 2 WHERE "id" = (SELECT "id" FROM sys_resource WHERE "name" = '玩家列表页' AND subsys_code = 'mcenterTopAgent')

