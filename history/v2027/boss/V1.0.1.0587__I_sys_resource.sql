-- auto gen by linsen 2018-07-23 18:02:47
-- 转账异常处理-修复 by linsen
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT  '90701', '修复', '', '转账异常处理-修复', '907', '', '1', 'boss', 'api:repairTransferOrder', '2', '', 'f', 't', 't'
WHERE NOT EXISTS (SELECT id FROM sys_resource WHERE id='90701');
