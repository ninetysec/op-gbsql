-- auto gen by george 2018-01-19 15:41:56
--添加报表导出模板上传功能
INSERT INTO "sys_resource"("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '214', '报表导出模板', 'exportTemplate/list.html', '报表导出模板', '2', NULL, '14', 'boss', 'serve:exportTemplate', '1', NULL, 'f', 't', 't'
WHERE NOT EXISTS (select id from sys_resource where id = '214');