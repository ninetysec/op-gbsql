-- auto gen by cherry 2017-08-02 10:59:21
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '8', '买分', '', '', NULL, '', '8', 'boss', 'boss:credit', '1', '', 't', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=8);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status")
SELECT '801', '收款账号', 'creditAccount/list.html', '收款账号', '8', '', '1', 'boss', 'credit:account', '1', '', 'f', 't', 't'
where not EXISTS (SELECT id FROM sys_resource where id=801);

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "privilege", "built_in", "status") SELECT '802', '充值记录', 'creditRecord/list.html', '充值记录', '8', '', '2', 'boss', 'system:creditRecord', '1', '', 'f', 't', 't' WHERE 802 NOT IN(SELECT id FROM sys_resource WHERE id=802);