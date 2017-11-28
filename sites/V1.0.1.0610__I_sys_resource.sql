-- auto gen by george 2017-11-28 19:34:17
INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '30102', '查看', '', '公司入款审核-查看', '301', '', NULL, 'mcenter', 'fund:companydeposit', '2', '', 't', 'f', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='30102');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '30304', '查看', 'fund/withdraw/withdrawAuditView.html', '玩家取款审核-查看', '303', '', NULL, 'mcenter', 'fund:playerwithdraw', '2', '', 't', 'f', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='30304');

INSERT INTO "sys_resource" ("id", "name", "url", "remark", "parent_id", "structure", "sort_num", "subsys_code", "permission", "resource_type", "icon", "built_in", "privilege", "status")
SELECT '30402', '查看', '', '代理取款审核-查看', '304', '', NULL, 'mcenter', 'fund:agentwithdraw', '2', '', 't', 'f', 't'
WHERE NOT EXISTS(SELECT ID FROM sys_resource WHERE ID='30402');