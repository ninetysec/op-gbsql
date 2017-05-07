-- auto gen by cherry 2016-11-11 10:04:41
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
select '608', '导出历史', 'exports/exportHistoryList.html', '导出任务列表', 6, NULL, 8, 'boss', 'system:export', '1', 'icon-zhandianlanmu', 't', 'f', 't'
where 608 not in (select id from sys_resource where id=608);