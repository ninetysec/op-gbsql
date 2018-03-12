-- auto gen by linsen 2018-03-04 20:15:52
-- author:younger
--添加API对账

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT  '413', 'API对账', 'report/apiCollateSite/index/boss.html', 'APl对帐报表', '4', '', '13', 'boss', 'report:apiCollateSite', '1', '', 'f', 't', 't' where NOT EXISTS (select id from sys_resource where id=413);
