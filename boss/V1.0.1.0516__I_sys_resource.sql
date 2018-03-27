-- auto gen by linsen 2018-02-27 16:43:00

--添加上分记录
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '806', '上分记录', 'upCreditRecord/list.html', '上分记录', '8', '', '5', 'boss', 'system:upCreditRecord', '1', '', 'f', 't', 't' WHERE not EXISTS (SELECT id FROM sys_resource where id=806); ;

