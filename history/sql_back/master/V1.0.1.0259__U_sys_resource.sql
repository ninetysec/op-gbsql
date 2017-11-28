-- auto gen by cheery 2015-12-11 02:50:53
update sys_resource set url='vCttDocument/list.html' where id=601;

UPDATE sys_resource SET url = 'topAgentAgent/list.html', remark = '总代管理-代理管理', sort_num = 2 WHERE "id" = (SELECT "id" FROM sys_resource WHERE "name" LIKE '代理管理%' AND subsys_code = 'mcenterTopAgent');