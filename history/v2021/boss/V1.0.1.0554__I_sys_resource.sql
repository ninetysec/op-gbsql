-- auto gen by linsen 2018-05-07 14:44:55
-- API转账监控配置 by leo
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '916', 'API转账监控配置', 'apiMonitorTransConf/list.html', 'API转账监控配置', '9', '', '16', 'boss', 'api:monitor_trans_conf', '1', '', 'f', 't', 't'
WHERE NOT EXISTS (SELECT id FROM sys_resource WHERE id=916);



UPDATE "sys_resource" SET "sort_num"='1'WHERE ("id"='905');

UPDATE "sys_resource" SET "sort_num"='2'WHERE ("id"='907');

UPDATE "sys_resource" SET "sort_num"='3'WHERE ("id"='904');

UPDATE "sys_resource" SET "sort_num"='4'WHERE ("id"='914');

UPDATE "sys_resource" SET "sort_num"='5'WHERE ("id"='908');

UPDATE "sys_resource" SET "sort_num"='6'WHERE ("id"='909');

UPDATE "sys_resource" SET "sort_num"='7', "parent_id"='9'WHERE ("id"='513');

UPDATE "sys_resource" SET "sort_num"='8'WHERE ("id"='911');

UPDATE "sys_resource" SET "sort_num"='9'WHERE ("id"='910');

UPDATE "sys_resource" SET "sort_num"='10'WHERE ("id"='912');

UPDATE "sys_resource" SET "sort_num"='11'WHERE ("id"='913');

UPDATE "sys_resource" SET "sort_num"='12'WHERE ("id"='901');

UPDATE "sys_resource" SET "sort_num"='13'WHERE ("id"='902');

UPDATE "sys_resource" SET "sort_num"='14'WHERE ("id"='903');

UPDATE "sys_resource" SET "sort_num"='15'WHERE ("id"='915');