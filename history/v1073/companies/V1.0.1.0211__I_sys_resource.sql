-- auto gen by cherry 2016-11-11 10:06:13
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '605', '导出历史', 'exports/exportHistoryList.html', '导出任务列表', 6, NULL, 5, 'ccenter', 'system:export', '1', 'icon-zhandianlanmu', 't', 'f', 't'
where 605 not in (select id from sys_resource where id=605);