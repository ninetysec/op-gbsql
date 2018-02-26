-- auto gen by linsen 2018-02-26 09:31:03
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '80202', '撤销充值记录', 'creditRecord/cancelOrder.html', '撤销充值记录', '802', '', '2', 'boss', 'creditRecord:cancel_order', '2', '', 'f', 't', 't'
WHERE 80202 NOT IN (SELECT ID FROM sys_resource WHERE ID = 80202);