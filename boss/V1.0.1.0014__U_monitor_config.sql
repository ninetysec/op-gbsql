-- auto gen by cherry 2016-03-08 14:37:37
UPDATE "monitor_config" SET  "method_name"='transferResult' WHERE (rule_instance='transferProcess');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '508', '转账异常处理', 'operation/exceptionTransfer/list.html', '转账异常处理', '5', NULL, '8', 'boss', 'maintenance:transfer', '1', NULL, 'f', 't', 't'
WHERE '508' not in (SELECT id FROM sys_resource where id='508');
