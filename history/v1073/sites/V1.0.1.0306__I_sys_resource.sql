-- auto gen by cherry 2016-11-11 10:07:43
update sys_resource set url='vUserPlayer/list.html' where id=32;

update sys_resource set url='exports/exportHistoryList.html' where id=712;

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '36', '导出历史', 'exports/exportHistoryList.html', '导出任务列表', NULL, NULL, 6, 'mcenterAgent', 'agent:export', '1', 'icon-zhandianlanmu', 't', 'f', 't'
where 36 not in (select id from sys_resource where id=36);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '26', '导出历史', 'exports/exportHistoryList.html', '导出任务列表', NULL, NULL, 6, 'mcenterTopAgent', 'topagent:export', '1', 'icon-zhandianlanmu', 't', 'f', 't'
where 26 not in (select id from sys_resource where id=26);