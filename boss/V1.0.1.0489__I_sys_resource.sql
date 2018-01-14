-- auto gen by george 2018-01-11 10:50:53

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '41001', '取消订单', NULL,  '取消订单', '410', NULL, '1', 'boss', 'bettingRecord:cancel_order', '2', NULL, 'f', 't', 't' WHERE '41001' NOT IN (SELECT id FROM sys_resource WHERE id='41001' );
