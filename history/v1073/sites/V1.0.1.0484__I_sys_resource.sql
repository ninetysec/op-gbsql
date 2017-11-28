-- auto gen by cherry 2017-07-24 17:24:44
DELETE FROM sys_resource where id=40401;
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
	SELECT '40402', '结算', 'fund/rebate/toSettled.html', '返佣结算-结算', '404', '', '1', 'mcenter', 'operate:rebatesettle', '2', '', 't', 'f', 't' where 40402 not in(SELECT id from sys_resource where id=40402);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
	SELECT '40403', '清除', 'fund/rebate/toSettled.html', '返佣结算-清除', '404', '', '2', 'mcenter', 'operate:rebateclear', '2', '', 't', 'f', 't' where 40403 not in(SELECT id from sys_resource where id=40403);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
	SELECT '40404', '挂账', 'fund/rebate/signBill.html', '返佣结算-挂账', '404', '', '3', 'mcenter', 'operate:rebatesignbill', '2', '', 't', 'f', 't' where 40404 not in(SELECT id from sys_resource where id=40404);
